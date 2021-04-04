//
//  AuthService.swift
//  ChatApp
//
//  Created by Tsibulko on 24.03.2021.
//

import UIKit
import Firebase
import  FirebaseAuth
import GoogleSignIn

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    } // end of func login
    
    
    func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping (Result<User, Error>) -> Void) {
        
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let auth = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    } // end of func googleLogin
    
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) == true
        else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.passwordsNotMatched))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    } // end of func register
    
    
} // end of class AuthService
