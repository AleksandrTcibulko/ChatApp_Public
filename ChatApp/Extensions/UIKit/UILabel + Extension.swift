//
//  UILabel + Extension.swift
//  ChatApp
//
//  Created by Tsibulko on 29.01.2021.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
