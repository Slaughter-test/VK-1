//
//  NetworkService.swift
//  VK-1
//
//  Created by Юрий Егоров on 17.01.2021.
//

import Foundation
import Alamofire

class NetworkService {

    //MARK: - Базовые данные
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.68"
    
    //MARK: - Список друзей
    func loadFriendList() {
        let path = "friends.get"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version,
            "fields": "city, domain"
        ]

        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value as Any)
        }
    }
    //MARK: - загрузить фото текущего юзера
    func loadPhotosList() {
        let path = "photos.getUserPhotos"
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
}
