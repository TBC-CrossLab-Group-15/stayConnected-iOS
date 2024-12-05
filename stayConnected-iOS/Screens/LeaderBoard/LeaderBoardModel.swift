//
//  LeaderBoardModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 05.12.24.
//

struct LeaderBoardModel: Codable {
    let avatar: String?
    let firstName: String
    let lastName: String
    let rating: Int
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case firstName = "first_name"
        case lastName = "last_name"
        case rating
    }
}
