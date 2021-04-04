//
//  MMessage-Comparable.swift
//  ChatApp
//
//  Created by Tsibulko on 03.04.2021.
//

import UIKit
import MessageKit

extension MMessage: Comparable {
    
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
