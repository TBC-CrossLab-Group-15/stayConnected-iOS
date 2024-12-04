//
//  PostModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 04.12.24.
//

struct PostModel: Codable {
    let title: String
    let text: String
    let tags: [Int]
}

struct PostModelResponse: Codable {
    let id: Int
    let title: String
    let text: String
    let tags: [Int]
    let user: String
}
