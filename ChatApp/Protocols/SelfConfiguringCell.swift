//
//  SelfConfiguringCell.swift
//  ChatApp
//
//  Created by Tsibulko on 21.03.2021.
//

import UIKit

protocol SelfConfiguringCell {
    
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
