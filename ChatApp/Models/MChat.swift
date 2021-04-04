//
//  MChat.swift
//  ChatApp
//
//  Created by Tsibulko on 21.03.2021.
//

import UIKit
import FirebaseFirestore

struct MChat: Hashable, Decodable {
    
    var friendUsername: String
    var friendAvatarStringURL: String
    var lastMessageContent : String
    var friendId: String
    
    init(friendUsername: String, friendAvatarStringURL: String, lastMessageContent: String, friendId: String) {
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard
            let friendUsername = data["friendUsername"] as? String,
            let friendAvatarStringURL = data["friendAvatarStringURL"] as? String,
            let lastMessageContent = data["lastMessage"] as? String,
            let friendId = data["friendId"] as? String
        else { return nil }
        
        self.friendUsername = friendUsername
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessageContent = lastMessageContent
        self.friendId = friendId
    }
    
    var representation: [String: Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendAvatarStringURL"] = friendAvatarStringURL
        rep["lastMessage"] = lastMessageContent
        rep["friendId"] = friendId
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
