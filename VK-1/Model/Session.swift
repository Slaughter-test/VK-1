//
//  Session.swift
//  VK-1
//
//  Created by Юрий Егоров on 11.01.2021.
//

import Foundation

class Session {
    
    static let instance = Session()
    
    private init(){}
    
    var token = ""
    var userId = 0
    
}
