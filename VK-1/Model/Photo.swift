//
//  Photo.swift
//  VK-1
//
//  Created by Юрий Егоров on 09.01.2021.
//

import UIKit
import SwiftyJSON

struct Photo: Codable {
    let photo: String
    let id: Int
    var like: Like
    
    
     init(_ json: JSON)  {
        self.photo = json["photo_604"].stringValue
        self.id = json["id"].intValue
        self.like = Like(json["likes"])
    }

}
struct Like: Codable {
    var userLikes: Int
    var count: Int
    
    init(_ json: JSON) {
        self.userLikes = json["user_likes"].intValue
        self.count = json["count"].intValue
    }

}
