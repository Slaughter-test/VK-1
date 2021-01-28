//
//  NetworkService.swift
//  VK-1
//
//  Created by Юрий Егоров on 17.01.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class NetworkService {

    //MARK: - Базовые данные
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.68"
    let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    //MARK: - Список друзей
    func saveList(_ list: [Object]) {
        do {
            let realm = try Realm(configuration: configuration)
            realm.beginWrite()
            realm.add(list, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func loadFriendList(completion: @escaping ([Friend]) -> Void) {
        let path = "friends.get"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version,
            "fields": "city, domain, photo",
            "order": "name"
        ]

        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self]
            response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                var friends = [Friend]()
                let friendsJSON = json["response"]["items"].arrayValue
                for friend in friendsJSON {
                    let f = Friend(friend)
                    friends.append(f)
                }
                friends.forEach { print($0.lastName)}
                self?.saveList(friends)
                completion(friends)
            case .failure(let error):
                print(error)
            }
    }
        }
    func loadSuggestedFriends(completion: @escaping ([Friend]) -> Void) {
        let path = "friends.getSuggestions"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version,
            "fields": "city, domain, photo",
            "order": "name"
        ]

        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self]
            response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                var friends = [Friend]()
                let friendsJSON = json["response"]["items"].arrayValue
                for friend in friendsJSON {
                    let f = Friend(friend)
                    friends.append(f)
                }
                friends.forEach { print($0.lastName)}
                self?.saveList(friends)
                completion(friends)
            case .failure(let error):
                print(error)
            }
    }
        }
    func addFriend(id: Int) {
        let path = "friends.add"
        let url = baseUrl+path
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": version,
            "user_id": String(id)
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData {
            response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                print(json)
            case .failure(let error):
                let json = JSON(error)
                print(json)
            }
        }
        
    }
    func getGroupsCatalog(completion: @escaping ([Group]) -> Void) {
        let path = "groups.getCatalog"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self]
            response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                var groups = [Group]()
                let groupsJSON = json["response"]["items"].arrayValue
                for group in groupsJSON {
                    let f = Group(group)
                    groups.append(f)
                }
                self?.saveList(groups)
                completion(groups)
            case .failure(let error):
                print(error)
            }
    }

    }
    
    func joinGroup(id: Int) {
        let path = "groups.join"
        let url = baseUrl+path
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": version,
            "group_id": String(-id)
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData {
            response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                print(json)
            case .failure(let error):
                let json = JSON(error)
                print(json)
            }
        }
    }
    
    func loadGroupList(completion: @escaping ([Group]) -> Void) {
        let path = "groups.get"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version,
            "fields": "city, domain, photo",
            "extended": "1"
        ]

        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self]
            response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                var groups = [Group]()
                let groupsJSON = json["response"]["items"].arrayValue
                for group in groupsJSON {
                    let f = Group(group)
                    groups.append(f)
                }
                self?.saveList(groups)
                completion(groups)
            case .failure(let error):
                print(error)
            }
    }
        }

            
    //MARK: - загрузить фото текущего юзера
    func loadPhotosList(_ id: Int, completion: @escaping ([Photo]) -> Void) {
        let albumPath = "photos.getAlbums"
        let photosPath = "photos.get"
        var albumsIds: Array<String> = ["wall", "profile"]
        let urlAlbums = baseUrl+albumPath
        let urlPhotos = baseUrl+photosPath
        var photosList = [Photo]()
        let parameters: Parameters = [
            "owner_id": id,
            "access_token": Session.instance.token,
            "v": version
        ]
        var parametersPhoto: Parameters = [
            "owner_id": id,
            "access_token": Session.instance.token,
            "v": version,
            "album_id": " ",
            "extended": "1"
        ]
        // тут запрашиваем альбомы , чтобы получить айдишники
        AF.request(urlAlbums, method: .get, parameters: parameters).responseJSON { [weak self] response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let albumsJSON = json["response"]["items"].arrayValue
                if albumsJSON.count != 0 {
                    for a in albumsJSON {
                        let album = Album(a)
                        albumsIds.append(String(album.id))
                }
                }
                // тут для кажддого айдишника делаем новый запрос на сервер(несколько айдишников нельзя :( )
                    for i in albumsIds {
                        parametersPhoto.updateValue(i, forKey: "album_id")
                        AF.request(urlPhotos, method: .get, parameters: parametersPhoto).responseJSON { response in
                            switch response.result {
                            case .success(let data):
                                let json = JSON(data)
                                let photosJSON = json["response"]["items"].arrayValue
                                for i in photosJSON {
                                    let photo = Photo(i)
                                    photosList.append(photo)
                                }
                                self?.saveList(photosList)
                                completion(photosList)
                            case .failure(let error):
                                print(error)
                            }
                    }
                }
                // я знаю что я дебил,  только после реализации нашел метод где можно выгрузить все фото
            case .failure(let error):
                print(error)
            }
    }
}
    //MARK: - загрузить список групп текущего юзера
    func getGroupsList() {
        let path = "groups.get"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version,
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value as Any)
    }

}
    //MARK: - поиск группы по вводу текста
    //search - текст поискового запроса
    
    func searchGroupsFromList(_ search: String) {
        let path = "groups.search"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version,
            "q": search
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value as Any)
    }
    }
    func setLike(_ userId: String, _ photoId: String, completion: @escaping (Bool) -> Void) {
        let path = "likes.add"
        let url = baseUrl+path
        var status: Bool = false
        let parameters: Parameters = [
            "owner_id": userId,
            "access_token": Session.instance.token,
            "v": version,
            "type": "photo",
            "item_id": photoId
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            switch response.result {
            case .success( _):
            status = true
                completion(status)
            case .failure(let error):
            status = false
                completion(status)
            print(error)
        }
    }
}
    func removeLike(_ userId: String, _ photoId: String, completion: @escaping (Bool) -> Void) {
        let path = "likes.delete"
        let url = baseUrl+path
        var status: Bool = false
        let parameters: Parameters = [
            "owner_id": userId,
            "access_token": Session.instance.token,
            "v": version,
            "type": "photo",
            "item_id": photoId
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            switch response.result {
            case .success( _):
            status = true
                completion(status)
            case .failure(let error):
            status = false
                completion(status)
            print(error)
        }
    }

}
}
struct Album {
    let id: Int
    
    
     init(_ json: JSON)  {
        self.id = json["id"].intValue
    }
}

