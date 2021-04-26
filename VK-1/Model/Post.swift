//
//  Post.swift
//  VK-1
//
//  Created by Юрий Егоров on 01.01.2021.
//

import UIKit
import SwiftyJSON

class Post: Codable {
    
    var likes: Int
    var userLikes: Int
    var text: String
    var comments: Int
    var views: Int
    var date: Double
    var photos: Array<String>
    var avatar: String
    var name: String
        
    init(_ json: JSON, _ photos: Array<String>, avatar: String, name: String) {
        self.date = json["date"].doubleValue
        self.text = json["text"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.userLikes = json["likes"]["user_likes"].intValue
        self.comments = json["comments"]["count"].intValue
        self.views = json["views"]["count"].intValue
        self.photos = photos
        self.avatar = avatar
        self.name = name
    }
}

extension Date {
  func asString(style: DateFormatter.Style) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = style
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: self)
  }
}
