//
//  AuthError.swift
//  ChatApp
//
//  Created by Tsibulko on 24.03.2021.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordsNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Please, fill all fields", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Please, use correct email format", comment: "")
        case .passwordsNotMatched:
            return NSLocalizedString("Passwords did't match", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown mistake", comment: "")
        case .serverError:
            return NSLocalizedString("Server mistake", comment: "")
        }
    }
} // end of extension AuthError: LocalizedError
