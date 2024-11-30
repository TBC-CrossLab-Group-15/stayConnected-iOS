//
//  QuestionModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

struct QuestionsResponse: Codable {
    let response: [QuestionModel]
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
    let likes_count: Int
}

struct User: Codable {
    let id: Int
    let username: String
}

struct QuestionModel: Codable {
    let id: Int
    let tags: [Tag]
    let answers: [Answer]
    let user: User
    let title: String
    let text: String
    let create_date: String
}



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
