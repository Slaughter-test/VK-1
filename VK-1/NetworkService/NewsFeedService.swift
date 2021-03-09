//
//  NewsFeedService.swift
//  VK-1
//
//  Created by Юрий Егоров on 02.03.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsFeedService {
    
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.68"
    
    func getPosts(completion: @escaping ([Post]) -> Void) {
    let path = "newsfeed.get"
    let url = baseUrl+path
    let parameters: Parameters = [
        "user_id": Session.instance.userId,
        "access_token": Session.instance.token,
        "v": version,
        "filter": "post"
    ]
        DispatchQueue.main.async {
            
            AF.request(url, method: .get, parameters: parameters).responseJSON {
                response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    var posts = [Post]()
                    let postsJSON = json["response"]["items"].arrayValue
                    let profiles = json["response"]["profiles"].arrayValue
                    let groups = json["response"]["groups"].arrayValue
                    for post in postsJSON {
                        var name = ""
                        var photos = [String]()
                        var avatar = ""
                        let postAttachments = post["attachments"].arrayValue
                        let id = post["source_id"].intValue
                        if post["copy_history"].exists() {
                        } else {
                        if post["type"].stringValue == "post" {
                        for attachment in postAttachments {
                            if attachment["type"].stringValue == "photo" {
                                let photourl = attachment["photo"]["photo_604"].stringValue
                                photos.append(photourl)
                            } else if attachment["type"].stringValue == "video" {
                                let photourl = attachment["video"]["photo_800"].stringValue
                                photos.append(photourl)
                            } else if attachment["type"].stringValue == "link" {
                                let photourl = attachment["link"]["photo"]["photo_604"].stringValue
                                photos.append(photourl)
                            } else if attachment["type"].stringValue == "doc" {
                                let photourl = attachment["doc"]["prieview"]["video"]["src"].stringValue
                                photos.append(photourl)
                            }
                        }
                        if id < 0 {
                            for group in groups {
                                if group["id"].intValue == -id {
                                    name = group["name"].stringValue
                                    avatar = group["photo_50"].stringValue
                            }
                        }
                        } else {
                            for profile in profiles {
                                if profile["id"].intValue == id {
                                    name = profile["first_name"].stringValue + " " + profile["last_name"].stringValue
                                    avatar = profile["photo_50"].stringValue
                                }
                            }
                        }
                        let f = Post(post, photos, avatar: avatar, name: name)
                        print("TTT" + "\(f.photos)")
                        posts.append(f)
                        }
                    }
                    }
                    completion(posts)
                case .failure(let error):
                    print(error)
                }
                
        }
    }
}
    func getPhotos() {
        let path = "newsfeed.get"
        let url = baseUrl+path
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "access_token": Session.instance.token,
            "v": version,
            "filter": "photos"
        ]
            DispatchQueue.main.async {
                
                AF.request(url, method: .get, parameters: parameters).responseJSON { response in
                    print(response.value as Any)
                    
            }
        }
    }
    

}
