//
//  UIButtonExtensions.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

extension UIButton {
    func configureCustomButton(title: String, color: UIColor, fontName: String, fontSize: CGFloat, cornerR: CGFloat = 0, bgColor: UIColor = .clear) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = UIFont(name: fontName, size: fontSize)
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerR
        self.backgroundColor = bgColor
    }
}
