//
//  PostAddViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import NetworkManagerFramework
import Foundation

protocol DidTagsRefreshed: AnyObject {
    func didTagsRefreshed()
}
protocol DidPostedSuccessfully: AnyObject {
    func didPostAddedSuccssfully()
}

protocol DidPostingFailed: AnyObject {
    func didPostingFailed()
}

final class PostAddViewModel {
    private let webService: NetworkServiceProtocol
    private let keyService: KeychainService
    private let tokenNetwork: TokenNetwork
    private let postService: PostServiceProtocol
    weak var delegate: DidTagsRefreshed?
    weak var successDelegate: DidPostedSuccessfully?
    weak var postingFailure: DidPostingFailed?
    var feedViewModel: FeedViewModel
    var activeTags: [Tag] = []
    var inactiveTags: [Tag] = []
    var errorMessage = ""
    
    init(
        webService: NetworkServiceProtocol = NetworkService(),
        keyService: KeychainService = KeychainService(),
        tokenNetwork: TokenNetwork = TokenNetwork(),
        postService: PostServiceProtocol = PostService(),
        feedViewModel: FeedViewModel = FeedViewModel()
    ) {
        self.webService = webService
        self.keyService = keyService
        self.tokenNetwork = tokenNetwork
        self.postService = postService
        self.feedViewModel = feedViewModel
        
        fetchTags(api: "https://stayconnected.lol/api/posts/tags/")
    }
    
    func fetchTags(api: String) {
        Task {
            do {
                let token = try keyService.retrieveAccessToken()
                
                let headers = ["Authorization": "Bearer \(token)"]
                try await getTags(api: api, headers: headers)
            } catch {
                if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                    await tokenNetwork.renewTokenAndRetry(api: api, retryFunction: getTags)
                } else {
                    handleNetworkError(error)
                }
            }
        }
    }
    
    func getTags(api: String, headers: [String : String]) async throws {
        let fetchedData: [Tag] = try await webService.fetchData(urlString: api, headers: headers)
        inactiveTags = fetchedData
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didTagsRefreshed()
        }
    }
    
    func singleActiveTag(at index: Int) -> Tag {
        return activeTags[index]
    }
    
    func removeActiveTag(at index: Int) {
        inactiveTags.append(activeTags[index])
        activeTags.remove(at: index)
    }
    
    func singleInactiveTag(at index: Int) -> Tag {
        return inactiveTags[index]
    }
    
    func removeInactiveTag(at index: Int) {
        activeTags.append(inactiveTags[index])
        inactiveTags.remove(at: index)
    }
    
    func postedPost(api: String, subject: String, question: String) {
        Task {
            do {
                let token = try keyService.retrieveAccessToken()
                let headers = ["Authorization": "Bearer \(token)"]
                try await postQuestion(api: api, subject: subject, question: question, headers: headers)
            } catch {
                if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                    await tokenNetwork.renewTokenAndRetry(api: api) {[weak self] api, headers in
                        try await self?.postQuestion(api: api, subject: subject, question: question, headers: headers)
                    }
                } else {
                    print("❌ Failed to post question: \(error.localizedDescription)")
                    handleNetworkError(error)
                    DispatchQueue.main.async {[weak self] in
                        self?.postingFailure?.didPostingFailed()
                    }
                }
            }
        }
    }
    
    func postQuestion(api: String, subject: String, question: String, headers: [String: String]) async throws {
        let tagIds = activeTags.map { $0.id }
        
        let body = PostModel(title: subject, text: question, tags: tagIds)
        
        do {
            let _ : PostModelResponse = try await postService.postData(urlString: api, headers: headers, body: body)
            DispatchQueue.main.async {[weak self] in
                self?.successDelegate?.didPostAddedSuccssfully()
            }
        } catch {
            print("Error: \(error)")
            errorMessage = error.localizedDescription
            throw error
        }
    }
}
