import Foundation

struct QuestionModel: Codable {
    let id: Int
    let tags: [Tag]
    let answers: [Answer]
    let user: User
    let title: String
    let text: String
    let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, tags, answers, user, title, text
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
        case id, text, isCorrect, user, question
        case createDate = "create_date"
    }
}

struct User: Codable {
    let id: Int
    let avatar: Avatar?
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id, avatar
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct Avatar: Codable {
    let id: Int
    let name: String
}
