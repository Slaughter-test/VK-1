//
//  Group.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit
import SwiftyJSON

struct Group: Codable {
    let name: String
    let photo: String
    let id: Int
    
    
     init(_ json: JSON)  {
        
        self.name = json["name"].stringValue
        self.photo = json["photo_100"].stringValue
        self.id = -(json["id"].intValue)
    }

}
