//
//  WaitingChatCell.swift
//  ChatApp
//
//  Created by Tsibulko on 21.03.2021.
//

import UIKit
import SDWebImage

class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    
    
    static var reuseId: String = "WaitingChatCell"
    
    let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        setupConstraints()
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat = value as? MChat else { return }
      //  friendImageView.image = UIImage(named: chat.userImageString)
        friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL), completed: nil)
    }
    
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
} // end of class WaitingChatCell

// MARK: - Setup Constraints

extension WaitingChatCell {
    
    private func setupConstraints() {
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(friendImageView)
        
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: self.topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
} // end of extension



//MARK: - для отображения в режиме Canvas

import SwiftUI

struct WaitingChatProvider: PreviewProvider {
    
    static var previews: some View {
        //чтобы игнорировать safe area при отображении добавляем .edgesIgnoringSafeArea(.all)
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
