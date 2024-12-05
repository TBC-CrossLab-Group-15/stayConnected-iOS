//
//  DetailViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 05.12.24.
//

import NetworkManagerFramework
import Foundation

protocol ReloadAnswersDelegate: AnyObject {
    func didAnswersFetched()
}

final class DetailViewModel {
    private let postService: PostServiceProtocol
    private let tokenNetwork: TokenNetwork
    private let keyService: TokenRetrieveProtocol
    private let webService: NetworkServiceProtocol
    var answersArray: [Answer] = []
    weak var delegate: ReloadAnswersDelegate?
    
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
    
    func getSinglePost(with postID: Int) {
        Task {
            let apiLink = "https://stayconnected.lol/api/posts/questions/\(postID)/"
            do {
                let response: QuestionModel = try await webService.fetchData(urlString: apiLink, headers: nil)
                answersArray = response.answers
                
                DispatchQueue.main.async {[weak self] in
                    self?.delegate?.didAnswersFetched()
                }
                print(response)
            } catch {
                handleNetworkError(error)
            }
        }
    }
    
    func singleAnswer(at index: Int) -> Answer {
        answersArray[index]
    }
    
    func collectAnswerInfo(api: String, answer: String, postID: Int) {
        let body = AnswerModel(text: answer, question: postID)
        
        Task {
            do {
                var token = try keyService.retrieveAccessToken()
                var headers = ["Authorization": "Bearer \(token)"]
                
                do {
                    let _: AnswerModel = try await postService.postData(urlString: api, headers: headers, body: body)
                    getSinglePost(with: postID)
                    
                } catch {
                    if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                        try await tokenNetwork.getNewToken()
                        token = try keyService.retrieveAccessToken()
                        headers = ["Authorization": "Bearer \(token)"]
                        
                        let _: AnswerModel = try await postService.postData(urlString: api, headers: headers, body: body)
                        getSinglePost(with: postID)
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
