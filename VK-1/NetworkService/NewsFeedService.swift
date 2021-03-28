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
    
    func getPosts(startTime: Double? = nil,
                  startFrom: String? = nil,
                  completion: @escaping ([Post], String) -> Void) {
    let path = "newsfeed.get"
    let url = baseUrl+path
    var parameters: Parameters = [
        "user_id": Session.instance.userId,
        "access_token": Session.instance.token,
        "v": version,
        "filter": "posts",
        "count": "10"
    ]
        
        if let startTime = startTime {
            parameters["start_time"] = startTime
        }
        
        if let startFrom = startFrom {
            parameters["start_from"] = startFrom
        }
        
        DispatchQueue.main.async {
            
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
                response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    var posts = [Post]()
                    let postsJSON = json["response"]["items"].arrayValue
                    let profiles = json["response"]["profiles"].arrayValue
                    let groups = json["response"]["groups"].arrayValue
                    let nextFrom = json["response"]["next_from"].stringValue
                    for post in postsJSON {
                        var name = ""
                        var photos = [String]()
                        var avatar = ""
                        var height = 0
                        var width = 0
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
                            width = postAttachments[0]["photo"]["width"].intValue
                            height = postAttachments[0]["photo"]["height"].intValue
                            print(width)
                            print(height)
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
                        let f = Post(post, photos, avatar: avatar, name: name, width: width, height: height)
                        posts.append(f)
                        }
                    }
                    }
                    completion(posts, nextFrom)
                case .failure(let error):
                    print(error)
                }
                
        }
    }
}
}
