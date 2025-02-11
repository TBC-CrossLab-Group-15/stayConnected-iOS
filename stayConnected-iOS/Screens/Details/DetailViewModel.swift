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
    private let putService: PutServiceProtocol
    private let keyService: TokenRetrieveProtocol
    private let webService: NetworkServiceProtocol
    private let deletionService: DeleteMethodPorotocol
    var answersArray: [Answer] = []
    weak var delegate: ReloadAnswersDelegate?
    
    init(
        postService: PostServiceProtocol = PostService(),
        tokenNetwork: TokenNetwork = TokenNetwork(),
        putService: PutServiceProtocol = PutService(),
        keyService: TokenRetrieveProtocol = KeychainService(),
        webService: NetworkServiceProtocol = NetworkService(),
        deletionService: DeleteMethodPorotocol = DeletionService()
    ) {
        self.postService = postService
        self.tokenNetwork = tokenNetwork
        self.putService = putService
        self.keyService = keyService
        self.webService = webService
        self.deletionService = deletionService
    }
    
    func refetchCurrentPostAnswers(with postID: Int) {
        Task {
            let apiLink = "\(EndpointsEnum.singelQuestion.rawValue)\(postID)"
            do {
                let response: QuestionModel = try await webService.fetchData(urlString: apiLink, headers: nil)
                answersArray = response.answers
                
              await MainActor.run {
                    delegate?.didAnswersFetched()
                }
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
                    refetchCurrentPostAnswers(with: postID)
                    
                } catch {
                    if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                        try await tokenNetwork.getNewToken()
                        token = try keyService.retrieveAccessToken()
                        headers = ["Authorization": "Bearer \(token)"]
                        
                        let _: AnswerModel = try await postService.postData(urlString: api, headers: headers, body: body)
                        refetchCurrentPostAnswers(with: postID)
                    } else {
                        throw error
                    }
                }
            } catch {
                handleNetworkError(error)
            }
        }
    }
    
    func checkAnswer(at index: Int, postID: Int) {
        let currentAnswer = answersArray[index]
        
        let api = "\(EndpointsEnum.answers.rawValue)\(currentAnswer.id)/"
        
        let body = AnswerStatusModel(isCorrect: !currentAnswer.isCorrect)
        
        Task{
            do {
                var token = try keyService.retrieveAccessToken()
                var headers = ["Authorization": "Bearer \(token)"]
                
                do {
                    let _: AnswerStatusModel = try await putService.putData(urlString: api, headers: headers, body: body)
                    
                    refetchCurrentPostAnswers(with: postID)
                } catch {
                    if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                        try await tokenNetwork.getNewToken()
                        token = try keyService.retrieveAccessToken()
                        headers = ["Authorization": "Bearer \(token)"]
                        
                        let _: AnswerStatusModel = try await putService.putData(urlString: api, headers: headers, body: body)
                        
                        refetchCurrentPostAnswers(with: postID)
                    } else {
                        throw error
                    }
                }
            }catch {
                handleNetworkError(error)
            }
        }
    }
    
    func deleteComment(with answerID: Int, and postID: Int) {
        let api = "\(EndpointsEnum.answers.rawValue)/\(answerID)/"
        Task{
            do {
                var token = try keyService.retrieveAccessToken()
                var headers = ["Authorization" : "Bearer \(token)"]
                
                do {
                    let _: () = try await deletionService.deleteData(urlString: api, headers: headers)
                    refetchCurrentPostAnswers(with: postID)
                } catch {
                    if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                        try await tokenNetwork.getNewToken()
                        token = try keyService.retrieveAccessToken()
                        headers = ["Authorization": "Bearer \(token)"]
                        
                        let _: () = try await deletionService.deleteData(urlString: api, headers: headers)
                        refetchCurrentPostAnswers(with: postID)
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







