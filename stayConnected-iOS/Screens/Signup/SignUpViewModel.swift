//
//  SignUpViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import Foundation
import UIKit
import NetworkManagerFramework

protocol SignupProtocol: AnyObject {
  func didRegistered()
}

final class SignUpViewModel {
  private let postService: PostServiceProtocol
  weak var delegate: SignupProtocol?
  
  init(postService: PostServiceProtocol = PostService()) {
    self.postService = postService
  }
  
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
  
  func signUpAction(firstName: String, lastName: String, email: String, password: String, confirmPassword: String) {
    
    let url = EndpointsEnum.register.rawValue
    
    let body = UserRegistrationModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword
    )
    Task {
      do {
        let headers = [
          "Content-Type": "application/json"
        ]
        let _: UserRegistrationModel = try await postService.postData(urlString: url, headers: headers, body: body)
        await MainActor.run {
          delegate?.didRegistered()
        }
      } catch {
        if let urlError = error as? URLError {
          print("URLError: \(urlError)")
        } else if let decodingError = error as? DecodingError {
          print("DecodingError: \(decodingError)")
        } else {
          print("Unknown Error: \(error)")
        }
      }
    }
  }
}
