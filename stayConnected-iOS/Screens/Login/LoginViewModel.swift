//
//  LoginViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import NetworkManagerFramework
import UIKit

protocol LoginNavigationDelegate: AnyObject {
    func navigateToFeed()
}

protocol LoginErrorDelegate: AnyObject {
    func didLoginFailed()
}

final class LoginViewModel {
    private let postService: PostServiceProtocol
    private let keyService: KeychainService
    weak var delegate: LoginNavigationDelegate?
    weak var errorDelebate: LoginErrorDelegate?
    
    init(postService: PostServiceProtocol = PostService(), keyService: KeychainService = KeychainService()) {
        self.keyService = keyService
        self.postService = postService
    }
    
    func loginAction(email: String, password: String) {
        let url = "https://stayconnected.lol/api/user/login/"
        
        let body = LoginRequest(email: email, password: password)
        
        Task {
            do {
                let response: LoginResponse = try await postService.postData(urlString: url, headers: nil, body: body)
        
                try keyService.storeTokens(access: response.access, refresh: response.refresh)
                try keyService.storeUserID(userID: String(response.userID))
                print("‼️ \(response.access)")
                print("✨ \(response.refresh)")
                DispatchQueue.main.async {[weak self] in
                    self?.delegate?.navigateToFeed()
                }
            } catch {
                DispatchQueue.main.async {[weak self] in
                    self?.errorDelebate?.didLoginFailed()
                }
                print("Error: \(error)")
            }
        }
    }
}
