//
//  SignUpModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 03.12.24.
//

import Foundation

struct UserRegistrationModel: Codable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
    let confirmPassword: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case confirmPassword = "confirm_password"
    }
}
