//
//  LoginModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 03.12.24.
//

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let access: String
    let refresh: String
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case access
        case refresh
        case userID = "user_id"
    }
}
