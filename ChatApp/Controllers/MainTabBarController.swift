//
//  MainTabBarController.swift
//  ChatApp
//
//  Created by Tsibulko on 17.03.2021.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    private let currentUser: MUser
    
    init(currentUser: MUser = MUser(username: "Default",
                                    email: "Default",
                                    avatarStringURL: "Default",
                                    description: "Default",
                                    sex: "Default",
                                    id: "Default")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)
        
        tabBar.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        let boldImageConfig = UIImage.SymbolConfiguration(weight: .bold)
        
        let conversationImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldImageConfig)!
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldImageConfig)!
        
        viewControllers = [
            generateNavigationController(rootViewController: peopleViewController, title: "People", image: peopleImage),
            generateNavigationController(rootViewController: listViewController, title: "Conversations", image: conversationImage)
        ]
        
    } // end of override func viewDidLoad()
    
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
     
} // end of class MainTabBarController: UITabBarController
