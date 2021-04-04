//
//  AuthViewController.swift
//  ChatApp
//
//  Created by Tsibulko on 29.01.2021.
//

import UIKit
import GoogleSignIn


class AuthViewController: UIViewController {

    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Alerady onboard?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonDark())
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroundColor: .white, isShadow: true)
    
    
    let signUPVC = SignUpViewController()
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleButton.customizedGoogleButton()
        view.backgroundColor = .white
        setupConstraints()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        loginVC.delegate = self
        signUPVC.delegate = self
        
        GIDSignIn.sharedInstance()?.delegate = self
        
    } // end of override func viewDidLoad()
    
    // MARK: - Button Actions
    
    @objc private func emailButtonTapped() {
        present(signUPVC, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc private func googleButtonTapped() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
} // end of class AuthViewController


// MARK: - Setup constraints

extension AuthViewController {
    
    private func setupConstraints() {
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
    } // end of private func setupConstraints()
    
} // end of extension AuthViewController

// MARK: - AuthNavigatingDelegate

extension AuthViewController: AuthNavigatingDelegate {
    
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSignUpVC() {
        present(signUPVC, animated: true, completion: nil)
    }
    
} // end of extension AuthViewController: AuthNavigatingDelegate


//MARK: - Google Auth

extension AuthViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        AuthService.shared.googleLogin(user: user, error: error) { (result) in
            switch result {
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { (result) in
                    switch result {
                    case .success(let muser):
                        UIApplication.getTopViewController()?.showAlert(with: "Congratulations!", and: "You are authorized!") {
                            let mainTabBar = MainTabBarController(currentUser: muser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            UIApplication.getTopViewController()?.present(mainTabBar, animated: true, completion: nil)
                        }
                    case .failure(_):
                        UIApplication.getTopViewController()?.showAlert(with: "Congratulations", and: "You are registered!") {
                            UIApplication.getTopViewController()?.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                        }
                    } // end of result
                }
            case .failure(let error):
                self.showAlert(with: "Oops!", and: error.localizedDescription)
            }
        }
    } // end of func sign
    
} // end of extension AuthViewController: GIDSignInDelegate



