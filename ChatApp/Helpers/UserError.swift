//
//  UserError.swift
//  ChatApp
//
//  Created by Tsibulko on 25.03.2021.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cannotGetUserInfo
    case cannotUnwrapToMUser
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Please, fill all fields", comment: "")
        case .photoNotExist:
            return NSLocalizedString("User did't take a photo", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Can't download user info from Firebase", comment: "")
        case .cannotUnwrapToMUser:
            return NSLocalizedString("Can't convert MUser из User", comment: "")
        }
    }
} // end of extension UserError: LocalizedError 
