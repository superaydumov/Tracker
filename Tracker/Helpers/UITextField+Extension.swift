//
//  UITextView+Extension.swift
//  Tracker
//
//  Created by Эльдар Айдумов on 15.10.2023.
//

import UIKit

extension UITextField {
    func indentSize(leftSize:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: leftSize, height: self.frame.height))
        self.leftViewMode = .always
    }
}
