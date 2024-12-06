//
//  UiViewControllerExtensions.swift
//  stayConnected-iOS
//
//  Created by Despo on 06.12.24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
