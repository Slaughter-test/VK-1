//
//  Friend.swift
//  VK-1
//
//  Created by Юрий Егоров on 02.01.2021.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Friend: Object {
    
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var photo: String = ""


    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(_ firstName: String, _ lastName: String, _ id: Int, _ photo: String) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.photo = photo
    }

}

class ParseDataOperation: Operation {

    var outputData: [Friend]?
    
    override func main() {
        guard let requestOperation = dependencies.first as? RequestOperation,
            let data = requestOperation.data else { return }
        let json = try! JSON(data: data)
        let friends: [Friend] = json["response"]["items"].compactMap {
            let id = $0.1["id"].intValue
            let firstName = $0.1["first_name"].stringValue
            let lastName = $0.1["last_name"].stringValue
            let photo = $0.1["photo"].stringValue
            
            return Friend(firstName, lastName, id, photo)
        }
        self.outputData = friends
    }
}

