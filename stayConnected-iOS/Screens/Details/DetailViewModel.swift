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
    private let webService: NetworkServiceProtocol
    
    init(
        postService: PostServiceProtocol = PostService(),
        tokenNetwork: TokenNetwork = TokenNetwork(),
        keyService: TokenRetrieveProtocol = KeychainService(),
        webService: NetworkServiceProtocol = NetworkService()
    ) {
        self.postService = postService
        self.tokenNetwork = tokenNetwork
        self.keyService = keyService
        self.webService = webService
    }
    
    func getSinglePost(with postID: Int) async throws -> QuestionModel {
        let apiLink = "https://stayconnected.lol/api/posts/questions/\(postID)/"
        do {
            let response: QuestionModel = try await webService.fetchData(urlString: apiLink, headers: nil)
            print(response)
            return response
        } catch {
            handleNetworkError(error)
            throw error
        }
    }
    
    func collectAnswerInfo(api: String, answer: String, postID: Int) {
        let body = AnswerModel(text: answer, question: postID)
        
        Task {
            do {
                var token = try keyService.retrieveAccessToken()
                var headers = ["Authorization": "Bearer \(token)"]
                
                do {
                    let _: AnswerModel = try await postService.postData(urlString: api, headers: headers, body: body)
                } catch {
                    if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                        
                        try await tokenNetwork.getNewToken()
                        token = try keyService.retrieveAccessToken()
                        headers = ["Authorization": "Bearer \(token)"]
                        
                        let _: AnswerModel = try await postService.postData(urlString: api, headers: headers, body: body)
                    } else {
                        throw error
                    }
                }
            } catch {
                handleNetworkError(error)
            }
        }
    }
}
