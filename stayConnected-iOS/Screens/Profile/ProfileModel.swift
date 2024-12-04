//
//  ProfileModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 04.12.24.
//

struct ProfileModel: Codable {
    let avatar: String?
    let firstName: String
    let lastName: String
    let email: String
    let rating: Int
    let myAnswers: Int
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case rating
        case myAnswers = "my_answers"
    }
}

struct AvatarReqBodyModel: Codable {
    let avatarId: String
    
    enum CodingKeys: String, CodingKey {
        case avatarId = "avatar_id"
    }
}
