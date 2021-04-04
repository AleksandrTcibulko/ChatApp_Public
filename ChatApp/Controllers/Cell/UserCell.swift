//
//  UserCell.swift
//  ChatApp
//
//  Created by Tsibulko on 22.03.2021.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    let userImageView = UIImageView()
    let userName = UILabel(text: "UserName", font: .laoSangamMN20())
    // делаем контейнер, чтобы можно было сделать и скругление и тени (когда делаешь скругление - вызываешь свойство cliptobounds - как следствие тени уже не сделать)
    let containerView = UIView()
    
    static var reuseId: String = "UserCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
        
        // картинка сверху не округляется, округляется только низ ячейки
        self.layer.cornerRadius = 4
        
        // добавляем тени
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    // теперь будет округлятся вся ячейка (спасибо созданному контейнеру)
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    
    // переопределение этого свойства - при переиспользовании ячейки - картинки уходят в nil
    override func prepareForReuse() {
        userImageView.image = nil
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user = value as? MUser else { return }
        //userImageView.image = UIImage(named: user.avatarStringURL)
        userName.text = user.username
        //setting image using special library - SDWebImage
        guard let url = URL(string: user.avatarStringURL) else { return }
        userImageView.sd_setImage(with: url, completed: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
} // end of class UserCell: UICollectionViewCell

// MARK: - Setup Constraints
extension UserCell {
    
    private func setupConstraints() {
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .red
         
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userName)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
            userName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        
    } // end of private func setupConstraints()
    
} // end of extension



//MARK: - для отображения в режиме Canvas

import SwiftUI

struct UserCellProvider: PreviewProvider {
    
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
