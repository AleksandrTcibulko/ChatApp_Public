//
//  UIStackView + Extension.swift
//  ChatApp
//
//  Created by Tsibulko on 29.01.2021.
//

import UIKit

extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat ) {
        
        self.init(arrangedSubviews: arrangedSubviews)
        
        self.axis = axis
        self.spacing = spacing
    }
}
