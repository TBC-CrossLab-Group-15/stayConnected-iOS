//
//  TokenNetwork.swift
//  stayConnected-iOS
//
//  Created by Despo on 04.12.24.
//

import NetworkManagerFramework

final class TokenNetwork {
    private let keyService: TokenRetrieveProtocol
    private let webService: PostServiceProtocol
    private var token = ""
    
    init(
        keyService: TokenRetrieveProtocol = KeychainService(),
        webService: PostServiceProtocol = PostService()
    ) {
        self.keyService = keyService
        self.webService = webService
    }
    
    func retrieveAccessToken() throws -> String {
        token = try keyService.retrieveRefreshToken()
        return token
    }
    
    func revokeToken() throws {
        let url = "https://stayconnected.lol/api/user/token/refresh/"
        
        let body = RefreshTokenModel(refresh: token)
        
        Task {
            do {
                let response: AccessTokenModel = try await webService.postData(
                    urlString: url,
                    headers: nil,
                    body: body
                )
                print("Response: \(response)")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
