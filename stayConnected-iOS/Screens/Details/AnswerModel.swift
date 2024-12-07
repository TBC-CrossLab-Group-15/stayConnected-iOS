//
//  AnswerModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 05.12.24.
//

struct AnswerModel: Codable {
    let text: String
    let question: Int
}

struct AnswerStatusModel: Codable {
    let isCorrect: Bool
}
