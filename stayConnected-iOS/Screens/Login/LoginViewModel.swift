//
//  LoginViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

struct RequestBody: Codable {
    let name: String
    let age: Int
}

struct ResponseBody: Codable {
    let success: Bool
    let message: String
}

import NetworkManagerFramework

final class LoginViewModel {
    private let postService: PostServiceProtocol
    
    init(postService: PostServiceProtocol = PostService()) {
        self.postService = postService
    }
    
    func postData() {
        
        let url = "http://localhost:3000/questPost"
            
            let body = RequestBody(name: "John Doe", age: 30)
            let headers = ["Authorization": "Bearer token"]
            
        
        Task {
            do {
                let response: ResponseBody = try await postService.postData(urlString: url, headers: headers, body: body)
                        print("Response: \(response)")
            } catch {
                print("Error: \(error)")

            }
        }
    }
}
