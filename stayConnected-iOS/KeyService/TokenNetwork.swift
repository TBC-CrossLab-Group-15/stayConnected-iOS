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
    
    init(
        keyService: TokenRetrieveProtocol = KeychainService(),
        webService: PostServiceProtocol = PostService()
    ) {
        self.keyService = keyService
        self.webService = webService
    }
    
    func getNewToken() async throws {
        let oldToken = try? keyService.retrieveAccessToken()
        print("⚠️ Old Token: \(oldToken ?? "Unavailable")")
        
        guard let refreshToken = try? keyService.retrieveRefreshToken() else {
            print("❌ Missing Refresh Token")
            throw NetworkError.noData
        }
        
        let url = "https://stayconnected.lol/api/user/token/refresh/"
        let body = RefreshTokenModel(refresh: refreshToken)
        
        do {
            let response: AccessTokenModel = try await webService.postData(
                urlString: url,
                headers: nil,
                body: body
            )
            print("🏆 New Token Retrieved: \(response)")
            try keyService.storeAccessTokens(access: response.access)
        } catch {
            print("❌ Failed to Refresh Token: \(error.localizedDescription)")
            throw error
        }
    }
    
    func renewTokenAndRetry<T>(
        api: String,
        retryFunction: (_ api: String, _ headers: [String: String]) async throws -> T
    ) async {
        do {
            try await getNewToken()
            print("🏆 Token successfully renewed")
            
            let newToken = try keyService.retrieveAccessToken()
            print("👉 Retrieved new access token: \(newToken)")
            
            let headers = ["Authorization": "Bearer \(newToken)"]
            print("🔑 Using Authorization Header: \(headers)")
            
            _ = try await retryFunction(api, headers)
        } catch let caughtError {
            print("❌ Token renewal failed: \(caughtError.localizedDescription)")
            if case NetworkError.statusCodeError(let statusCode) = caughtError {
                print("❌ Unexpected status code during retry: \(statusCode)")
            } else {
                print("❌ General Error: \(caughtError)")
            }
        }
    }
}
