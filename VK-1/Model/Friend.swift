//
//  Friend.swift
//  VK-1
//
//  Created by Юрий Егоров on 02.01.2021.
//

import UIKit
import SwiftyJSON

struct Friend: Codable {
    let firstName: String
    let lastName: String
    let photo: String
    let id: Int
    
    
     init(_ json: JSON)  {
        
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = json["photo"].stringValue
        self.id = json["id"].intValue
    }

}
