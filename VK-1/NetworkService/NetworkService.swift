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
import FirebaseDatabase
import PromiseKit

protocol NetworkServiceInterface {
    func loadSuggestedFriends(completion: @escaping ([Friend]) -> Void)
    func addFriend(id: Int)
    func deleteFriend(id: Int)
    func getGroupsCatalog(on queue: DispatchQueue) -> Promise<[Group]>
    func joinGroup(id: Int)
    func deleteGroup(id: Int)
    func loadGroupList(on queue: DispatchQueue) -> Promise<[Group]>
    func loadPhotosList(_ id: Int, completion: @escaping ([Photo]) -> Void)
    func setLike(_ userId: String, _ photoId: String, completion: @escaping (Bool) -> Void)
    func removeLike(_ userId: String, _ photoId: String, completion: @escaping (Bool) -> Void)
    
}

class NetworkService: NetworkServiceInterface {
    
    //MARK: - Firebase
    var ref = Database.database().reference()
    //MARK: - Базовые данные
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.68"
    
    //MARK: - Realm
    let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    public func saveList(_ list: [Object]) {
        do {
            let realm = try Realm(configuration: configuration)
            realm.beginWrite()
            realm.add(list, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
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

        
        Alamofire.request(url, method: .get, parameters: parameters).responseData {
            response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let friends: [Friend] = json["response"]["items"].compactMap {
                    let id = $0.1["id"].intValue
                    let firstName = $0.1["first_name"].stringValue
                    let lastName = $0.1["last_name"].stringValue
                    let photo = $0.1["photo"].stringValue
                    
                    return Friend(firstName, lastName, id, photo)
                }
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
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData {
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
    func deleteFriend(id: Int) {
        let path = "friends.delete"
        let url = baseUrl+path
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": version,
            "user_id": String(id)
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData {
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
    //MARK: - Получение возможных групп для вступления
    
    func getGroupsCatalog(on queue: DispatchQueue = .main) -> Promise<[Group]>  {
        let path = "groups.getCatalog"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version
        ]
        
        return Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON()
            .map(on: queue) {
                json, response -> [Group] in
                let json = JSON(json)
                var groups = [Group]()
                let groupsJSON = json["response"]["items"].arrayValue
                for group in groupsJSON {
                    if group["is_member"].intValue == 0 {
                    let f = Group(group)
                    groups.append(f)
            }
                }
                return groups
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
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData {
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
    
    func deleteGroup(id: Int) {
        let path = "groups.leave"
        let url = baseUrl+path
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": version,
            "group_id": String(-id)
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData {
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
    
    func loadGroupList(on queue: DispatchQueue = .global()) -> Promise<[Group]> {
        let path = "groups.get"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version,
            "fields": "city, domain, photo",
            "extended": "1"
        ]
        
        return Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON()
            .map(on: queue) {
                json, response -> [Group] in
                let json = JSON(json)
                var groups = [Group]()
                let groupsJSON = json["response"]["items"].arrayValue
                for group in groupsJSON {
                    let f = Group(group)
                    groups.append(f)
            }
                return groups
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
        Alamofire.request(urlAlbums, method: .get, parameters: parameters).responseJSON { [weak self] response in
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
                        Alamofire.request(urlPhotos, method: .get, parameters: parametersPhoto).responseJSON { response in
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
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
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
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
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
    
struct Album {
    let id: Int
    
    
     init(_ json: JSON)  {
        self.id = json["id"].intValue
    }
}
}
class NetworkServiceProxy: NetworkServiceInterface {
    
    let networkService: NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadSuggestedFriends(completion: @escaping ([Friend]) -> Void) {
        self.networkService.loadSuggestedFriends(completion: completion)
        print("called func loadSuggestedFriends")
    }
    
    func addFriend(id: Int) {
        self.networkService.addFriend(id: id)
        print("called func addFriend with \(id)")
    }
    
    func deleteFriend(id: Int) {
        self.networkService.deleteFriend(id: id)
        print("called func deleteFriend with \(id)")
    }
    
    func getGroupsCatalog(on queue: DispatchQueue) -> Promise<[Group]> {
        print("called func getGroupCatalog")
        return self.networkService.getGroupsCatalog(on: queue)
    }
    
    func joinGroup(id: Int) {
        self.networkService.joinGroup(id: id)
        print("called func joinGroup with \(id)")

    }
    
    func deleteGroup(id: Int) {
        self.networkService.joinGroup(id: id)
        print("called func joinGroup with \(id)")
    }
    
    func loadGroupList(on queue: DispatchQueue) -> Promise<[Group]> {
        print("called func loadGroupList")
        return self.networkService.loadGroupList(on: queue)
    }
    
    func loadPhotosList(_ id: Int, completion: @escaping ([Photo]) -> Void) {
        self.networkService.loadPhotosList(id, completion: completion)
        print("called func loadPhotosList with id \(id)")
    }
    
    func setLike(_ userId: String, _ photoId: String, completion: @escaping (Bool) -> Void) {
        self.networkService.setLike(userId, photoId, completion: completion)
        print("called func setLike on photo with \(photoId) of user \(userId)")
    }
    
    func removeLike(_ userId: String, _ photoId: String, completion: @escaping (Bool) -> Void) {
        self.networkService.setLike(userId, photoId, completion: completion)
        print("called func removeLike on photo with \(photoId) of user \(userId)")
    }
    
}
