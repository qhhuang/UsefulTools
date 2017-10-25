//
//  UILabel+Extension.swift
//  UILabel 单击复制Label内容
//
//  Created by qhhuang on 13/07/2017.
//  Copyright © 2017 qhhuang. All rights reserved.
//

import Foundation
import ObjectiveC


private var can_BD_Copy: Bool = false

extension UILabel {
    
    var canCopy: Bool {
        get {
            return objc_getAssociatedObject(self, &can_BD_Copy) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &can_BD_Copy, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            attachTapHandler()
            
        }
    }
    
    //第一响应者
    open override var canBecomeFirstResponder: Bool {
        return canCopy
    }
    
    //针对复制的操作覆盖方法
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UILabel.copyText(sender:))
    }
    
    @objc func copyText(sender: Any) {
        let pBoard = UIPasteboard.general
        pBoard.string = self.text
    }
    
    
    func attachTapHandler() {
        self.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(UILabel.handleTap(ges:)))
        self.addGestureRecognizer(longPress)
    }
    
    @objc fileprivate func handleTap(ges: UIGestureRecognizer) {
        becomeFirstResponder()
        let item = UIMenuItem(title: "复制", action: #selector(UILabel.copyText(sender:)))
        UIMenuController.shared.menuItems = [item]
        UIMenuController.shared.setTargetRect(self.frame, in: self.superview!)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }

}
