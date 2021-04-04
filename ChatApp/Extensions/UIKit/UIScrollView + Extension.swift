//
//  UIScrollView + Extension.swift
//  ChatApp
//
//  Created by Tsibulko on 03.04.2021.
//

import UIKit


extension UIScrollView {
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForBottom: CGFloat {
      let scrollViewHeight = bounds.height
      let scrollContentSizeHeight = contentSize.height
      let bottomInset = contentInset.bottom
      let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
      return scrollViewBottomOffset
    }
}
