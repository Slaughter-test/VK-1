//
//  Photo.swift
//  VK-1
//
//  Created by Юрий Егоров on 09.01.2021.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Photo: Object, Codable {

    @objc dynamic var photo: String = ""
    dynamic var like: Like?
    @objc dynamic var id: Int = 0
    
    
     convenience init(_ json: JSON)  {
        self.init()
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
