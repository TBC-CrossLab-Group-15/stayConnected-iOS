//
//  DetailViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 05.12.24.
//

import NetworkManagerFramework

final class DetailViewModel {
    private let postService: PostServiceProtocol
    private let tokenNetwork: TokenNetwork
    private let keyService: TokenRetrieveProtocol
    
    init(
        postService: PostServiceProtocol = PostService(),
        tokenNetwork: TokenNetwork = TokenNetwork(),
        keyService: TokenRetrieveProtocol = KeychainService()
    ) {
        self.postService = postService
        self.tokenNetwork = tokenNetwork
        self.keyService = keyService
    }
    
    func sendAnswer(api: String, answer: String, postID: Int) {
        Task {
            do {
                let token = try keyService.retrieveAccessToken()
                print("✅ Token Retrieved: \(token)")
                
                let headers = ["Authorization": "Bearer \(token)"]
                try await collectAnswerInfo(api: api, headers: headers, answer: answer, postID: postID)
            } catch {
                if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                    print("⚠️ Token expired, attempting to renew...")
                    await tokenNetwork.renewTokenAndRetry(api: api) { [weak self] api, headers in
                        try await self?.collectAnswerInfo(api: api, headers: headers, answer: answer, postID: postID)
                    }
                } else {
                    print("❌ Failed to post answer: \(error.localizedDescription)")
                    handleNetworkError(error)
                }
            }
        }
    }
    
    func collectAnswerInfo(api: String, headers: [String : String] , answer: String, postID: Int) async throws {
        let body = AnswerModel(text: answer, question: postID)
        
        do {
            let _: AnswerModel = try await postService.postData(urlString: api, headers: headers, body: body)
        } catch {
            print(error)
        }
    }
    
    
}
