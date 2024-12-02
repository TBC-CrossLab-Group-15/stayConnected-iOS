//
//  QuestionModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import Foundation

struct QuestionsResponse: Codable {
    let response: [QuestionModel]
}

struct QuestionModel: Codable {
    let id: Int
    let tags: [Tag]
    let answers: [Answer]
    let user: User
    let title: String
    let text: String
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case tags
        case answers
        case user
        case title
        case text
        case createDate = "create_date"
    }
}

struct Tag: Codable {
    let id: Int
    let name: String
}

struct Answer: Codable {
    let id: Int
    let text: String
    let isCorrect: Bool
    let user: User
    let question: Int
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case isCorrect
        case user
        case question
        case createDate = "create_date"
    }
}

struct User: Codable {
    let id: Int
    let avatar: Avatar
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case avatar
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct Avatar: Codable {
    let id: Int
    let name: String
}

