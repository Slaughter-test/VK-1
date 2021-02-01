//
//  Group.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Group: Object, Codable {
    @objc dynamic var name: String = ""
    @objc dynamic var photo: String = ""
    @objc dynamic var id: Int = 0
    
     convenience init(_ json: JSON)  {
        self.init()
        self.name = json["name"].stringValue
        self.photo = json["photo_100"].stringValue
        self.id = -(json["id"].intValue)
    }
    override static func primaryKey() -> String? {
        return "id"
    }

}
