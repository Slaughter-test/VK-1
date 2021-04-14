//
//  FriendsNetworkAdapter.swift
//  VK-1
//
//  Created by Юрий Егоров on 14.04.2021.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire

final class FriendsNetworkAdapter {
    
    let networkService = NetworkService()
    let operationQueue = OperationQueue()
    let url = "https://api.vk.com/method/friends.get"
    let parameters: Parameters = [
        "user_id": Session.instance.userId,
        "access_token": Session.instance.token,
        "v": "5.68",
        "fields": "city, domain, photo",
        "order": "name"
    ]

    func getFriends(then completion: @escaping ([Friend]) -> Void) {
        let request = Alamofire.request(url,
                                 method: .get,
                                 parameters: parameters)
        
        let rp = RequestOperation(request: request)
        let parseOp = ParseDataOperation()
        parseOp.addDependency(rp)
        let realmOp = RealmOperations()
        realmOp.addDependency(parseOp)
        operationQueue.addOperations([rp, parseOp, realmOp], waitUntilFinished: false)
        
        guard let realm = try? Realm().objects(Friend.self).sorted(byKeyPath: "lastName") else {
            return
        }
        let friends = realmFriends(from: realm)
        completion(friends)
    }
    
    func deleteFriend(friend: Friend) {
        networkService.deleteFriend(id: friend.id)
        realmDelete(id: friend.id)
    }
    
    private func realmFriends(from results: Results<Friend>) -> [Friend]{
        return results.toArray(ofType: Friend.self)
    }
    
    private func realmDelete(id: Int) {
        
        do {
            let realm = try Realm()

            let object = realm.objects(Friend.self).filter("id = %@", id).first

            try! realm.write {
                if let obj = object {
                    realm.delete(obj)
                }
            }
        } catch let error as NSError {
            print("error - \(error.localizedDescription)")
        }
    }
    
}

