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
    let create_date: String
    
    enum CodingKeys: String, CodingKey {
        case id, tags, answers, user, title, text
        case create_date = "createDate"
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
    let create_date: String
    let likes: [Int]
    let likes_count: Int
    
    enum CodingKeys: String, CodingKey {
        case id, text, isCorrect, user, question, likes
        case create_date = "createDate"
        case likes_count = "likesCount"
    }
}

struct User: Codable {
    let id: Int
    let username: String
}


//    enum CodingKeys: String, CodingKey {
//        case id, text, isCorrect, user, question
//        case createDate = "create_date"
//        case likes, likesCount = "likes_count"
//    }


//{
//    "id": 4,
//    "tags": [
//        {
//            "id": 4,
//            "name": "java"
//        }
//    ],
//    "answers": [
//        {
//            "id": 5,
//            "text": "bla",
//            "isCorrect": true,
//            "user": {
//                "id": 3,
//                "username": "guka"
//            },
//            "question": 4,
//            "create_date": "2024-11-30T16:32:01.033917Z",
//            "likes": [],
//            "likes_count": 0
//        }
//    ],
//    "user": {
//        "id": 1,
//        "username": "misho"
//    },
//    "title": "misho",
//    "text": "mishooo",
//    "create_date": "2024-11-30T16:31:42.534410Z"
//}
