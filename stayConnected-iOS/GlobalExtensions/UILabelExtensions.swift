//
//  UILabelExtensions.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

extension UILabel {
    func configureCustomText(text: String, color: UIColor, fontName: String, size: CGFloat, alignment: NSTextAlignment = .left, lineNumber: Int = 0) {
        self.text = text
        self.textColor = color
        self.font = UIFont(name: fontName, size: size)
        self.textAlignment = alignment
        self.numberOfLines = lineNumber
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
