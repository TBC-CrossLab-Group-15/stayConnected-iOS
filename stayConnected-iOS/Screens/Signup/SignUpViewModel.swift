//
//  SignUpViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import Foundation
import UIKit

final class SignUpViewModel {
        
    func stringCheck(_ string: String) -> Bool {
        let regex = "^[a-zA-Z]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    func strongPasswordCheck(_ password: String) -> Bool {
        let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).+$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return predicate.evaluate(with: password)
    }

    
    func checkPasswords(pwdOne: String, pwdTwo: String) -> Bool {
        if pwdOne == pwdTwo {
            return true
        } else {
            return false
        }
    }
}
