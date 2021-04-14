//
//  FriendsViewModelFactory.swift
//  VK-1
//
//  Created by Юрий Егоров on 14.04.2021.
//

import Foundation
import UIKit

struct FriendViewModel {
    let friendText: String
    let avatar: String
}


final class FriendsViewModelFactory {
    
    func constructViewModels(from friends: [Friend]) -> [FriendViewModel] {
        return friends.compactMap(self.viewModel)
    }
    
    private func viewModel(from friend: Friend) -> FriendViewModel {
        let friendText = friend.firstName + " " + friend.lastName
        let friendAvatar = friend.photo
        return FriendViewModel(friendText: friendText, avatar: friendAvatar)
    }
    
}
