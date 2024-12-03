//
//  KeyChain.swift
//  stayConnected-iOS
//
//  Created by Despo on 03.12.24.
//
import SimpleKeychain
import NetworkManagerFramework

final class KeychainService {
    let keyService: SimpleKeychain
    let webService: PostServiceProtocol
    
    init(keyService: SimpleKeychain = SimpleKeychain(), webService: PostServiceProtocol = PostService()) {
        self.keyService = keyService
        self.webService = webService
    }
    
    func storeTokens(access: String, refresh: String) throws {
        try keyService.set(access, forKey: "accessToken")
        try keyService.set(refresh, forKey: "refreshToken")
    }
    
    func retrieveAccessToken() throws -> String{
        try keyService.string(forKey: "accessToken")
    }
    
    func retrieveRefreshToken() throws -> String{
        try keyService.string(forKey: "refreshToken")
    }
    
    func revokeToken() throws {
        let url = "https://stayconnected.lol/api/user/token/refresh/"
        let refreshToken = try retrieveRefreshToken()
        
        let body = RefreshTokenModel(refresh: refreshToken)
        
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
