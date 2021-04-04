//
//  WaitingChatsNavigation .swift
//  ChatApp
//
//  Created by Tsibulko on 28.03.2021.
//

import UIKit

protocol WaitingChatsNavigation: class {
    
    func removeWaitingChat(chat: MChat)
    func changeToActive(chat: MChat)
}
