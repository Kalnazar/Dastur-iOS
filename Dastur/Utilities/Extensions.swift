//
//  UIView+Extension.swift
//  Dastur
//
//  Created by Саят Калназар on 23.05.2023.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
