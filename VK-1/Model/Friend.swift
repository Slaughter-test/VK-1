//
//  Friend.swift
//  VK-1
//
//  Created by Юрий Егоров on 02.01.2021.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Friend: Object, Codable {
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var photo = ""
    @objc dynamic var id = 0

    
    
     convenience init(_ json: JSON)  {
        self.init()
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = json["photo"].stringValue
        self.id = json["id"].intValue
    }

}
