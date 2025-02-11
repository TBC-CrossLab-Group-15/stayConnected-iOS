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
    
    let url = EndpointsEnum.token.rawValue
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
}
