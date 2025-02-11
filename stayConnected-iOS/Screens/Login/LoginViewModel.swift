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
      let url = EndpointsEnum.login.rawValue
        
        let body = LoginRequest(email: email, password: password)
        
      Task { [weak self] in
          guard let self = self else { return }
        print(body)

          do {
              let response: LoginResponse = try await self.postService.postData(urlString: url, headers: nil, body: body)

              try self.keyService.storeTokens(access: response.access, refresh: response.refresh)
              try self.keyService.storeUserID(userID: String(response.userID))

            await MainActor.run {
                  self.delegate?.navigateToFeed()
              }
          } catch {
            await MainActor.run {
                  self.errorDelebate?.didLoginFailed()
              }
          }
      }
    }
}
