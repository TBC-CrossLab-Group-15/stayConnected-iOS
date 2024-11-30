//
//  QuestionModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

struct QuestionsResponse: Codable {
    let response: [QuestionModel]
}

struct QuestionModel: Codable {
    let topicTitle: String
    let question: String
    let repliesCount: Int
    let isAnswered: Bool
    let tags: [String]
}
