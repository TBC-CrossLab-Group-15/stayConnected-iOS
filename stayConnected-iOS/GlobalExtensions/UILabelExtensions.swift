//
//  UILabelExtensions.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

extension UILabel {
    func configureCustomText(text: String, color: UIColor, size: CGFloat, weight: UIFont.Weight , alignment: NSTextAlignment = .left, lineNumber: Int = 0) {
        self.text = text
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.textAlignment = alignment
        self.numberOfLines = lineNumber
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
