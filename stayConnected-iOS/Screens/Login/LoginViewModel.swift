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
import UIKit

final class LoginViewModel {
    private let postService: PostServiceProtocol
    
    init(postService: PostServiceProtocol = PostService()) {
        self.postService = postService
    }
    
    func loginAction(email: String, password: String) {
        let url = "https://stayconnected.lol/api/user/login/"
        
        let body = LoginRequest(email: email, password: password)
        
        Task {
            do {
                let response: LoginResponse = try await postService.postData(urlString: url, headers: nil, body: body)
                print("Response: \(response)")
                print("🟢")
                
                DispatchQueue.main.async {[weak self] in
                    self?.navigationToFeed()
                }
            } catch {
                print("Error: \(error)")
                print("🔴")
            }
        }
    }
    
    private func navigationToFeed() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = TabBarController()
    }
}
