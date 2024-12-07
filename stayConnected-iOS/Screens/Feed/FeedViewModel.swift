//
//  FeedViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import NetworkManagerFramework
import Foundation

protocol FeedModelDelegate: AnyObject {
    func didDataFetched()
}

protocol SearchedInfoDelegate: AnyObject {
    func didSearchedInfoFetched()
}

protocol TagsModelDelegate: AnyObject {
    func didTagsFetched()
}

protocol RefreshFeedDelegate: AnyObject {
    func didFeedRefreshed()
}

final class FeedViewModel {
    private var pageCount = 0
    private var totalCount = 0
    private var isSearching = false
    var isPersonalData = false
    private let tagApiLink = "https://stayconnected.lol/api/posts/tags/"
    private let webService: NetworkServiceProtocol
    private let deletionService: DeleteMethodPorotocol
    private var questionsArray: [QuestionModel] = []
    private let keyService: KeychainService
    private let tokenNetwork: TokenNetwork
    weak var delegate: FeedModelDelegate?
    weak var tagsDelegate: TagsModelDelegate?
    weak var feedRefreshDelegate: RefreshFeedDelegate?
    weak var searchedInfoDelegate: SearchedInfoDelegate?
    
    var tagsArray: [Tag] = [Tag(id: -1, name: "All")]
    
    init(
        webService: NetworkServiceProtocol = NetworkService(),
        keyService: KeychainService = KeychainService(),
        tokenNetwork: TokenNetwork = TokenNetwork(),
        deletionService: DeleteMethodPorotocol = DeletionService()
    ) {
        self.webService = webService
        self.keyService = keyService
        self.tokenNetwork = tokenNetwork
        self.deletionService = deletionService
        fetchTagsData(api: tagApiLink)
    }
    
    var questionsCount: Int {
        questionsArray.count
    }
    
    func fetchData(api: String) {
        print("⚠️")
        Task {
            do {
                let fetchedData: QuestionsResponse = try await webService.fetchData(urlString: api, headers: [:])
                totalCount = fetchedData.count
                questionsArray = fetchedData.results
                DispatchQueue.main.async {[weak self] in
                    self?.delegate?.didDataFetched()
                }
            } catch {
                print("❌")
                handleNetworkError(error)
            }
        }
    }
    
    private func fetchTagsData(api: String) {
        Task {
            do {
                let fetchedData: [Tag] = try await webService.fetchData(urlString: api, headers: [:])
                tagsArray.append(contentsOf: fetchedData)
                DispatchQueue.main.async {[weak self] in
                    self?.tagsDelegate?.didTagsFetched()
                }
            } catch {
                handleNetworkError(error)
            }
        }
    }
    
    func singleQuestion(with index: Int) -> QuestionModel {
        questionsArray[index]
    }
    
    func singleTag(whit index: Int) -> Tag {
        tagsArray[index]
    }
    
    func updatePages() {
        isPersonalData = false
        print(isPersonalData)
        
        guard !isSearching else { return }
        
        pageCount += 10
        let apiLink = "https://stayconnected.lol/api/posts/questions/?page=1&page_size=\(pageCount)"
        fetchData(api: apiLink)
        
        print("count: \(pageCount) : total: \(totalCount)")
    }
    
    func searchByTag(with tag: String) {
        isPersonalData = false
        
        if tag == "All" {
            isSearching = false
            let apiLink = "https://stayconnected.lol/api/posts/questions/?page=1&page_size=\(pageCount)"
            fetchData(api: apiLink)
        }
        
        isSearching = true
        let apiLink = "https://stayconnected.lol/api/posts/search/?search=\(tag)"
        
        Task {
            do {
                let searchedPosts: [QuestionModel] = try await webService.fetchData(urlString: apiLink, headers: nil)
                questionsArray = []
                questionsArray.append(contentsOf: searchedPosts)
                DispatchQueue.main.async {[weak self] in
                    self?.searchedInfoDelegate?.didSearchedInfoFetched()
                }
            } catch {
                handleNetworkError(error)
            }
        }
    }
    
    func searchByTitle(with title: String) {
        isPersonalData = false
        if title == "" {
            isSearching = false
            let apiLink = "https://stayconnected.lol/api/posts/questions/?page=1&page_size=\(pageCount)"
            fetchData(api: apiLink)
        }
        
        guard !title.isEmpty else { return }
        
        isSearching = true
        let apiLink = "https://stayconnected.lol/api/posts/search/question/?search=\(title)"
        
        Task {
            do {
                let searchedPosts: [QuestionModel] = try await webService.fetchData(urlString: apiLink, headers: nil)
                questionsArray = []
                questionsArray = searchedPosts
                DispatchQueue.main.async {[weak self] in
                    self?.searchedInfoDelegate?.didSearchedInfoFetched()
                }
            } catch {
                handleNetworkError(error)
            }
        }
    }
    
    func currentUserQuestions() {
        let api = "https://stayconnected.lol/api/user/currentuserquestions/"
        
        Task {
            do {
                var token = try keyService.retrieveAccessToken()
                var headers = ["Authorization": "Bearer \(token)"]
                
                do{
                    try await fetchMyQuestions(api: api, headers: headers)
                } catch {
                    if case NetworkError.statusCodeError(statusCode: let statusCode) = error, statusCode == 401 {
                        
                        try await tokenNetwork.getNewToken()
                        token = try keyService.retrieveAccessToken()
                        headers = ["Authorization": "Bearer \(token)"]
                        
                        try await fetchMyQuestions(api: api, headers: headers)
                    }
                }
            }
        }
    }
    
    func fetchMyQuestions(api: String, headers: [String : String]) async throws {
        isPersonalData = true
        print(isPersonalData)
        
        let response: [QuestionModel] = try await webService.fetchData(urlString: api, headers: headers)
        questionsArray = response
        
        DispatchQueue.main.async {[weak self] in
            self?.delegate?.didDataFetched()
        }
    }
    
    func deletePost(with id: Int) {
        let api = "https://stayconnected.lol/api/posts/questions/\(id)/"
        
        Task{
            do {
                var token = try keyService.retrieveAccessToken()
                var headers = ["Authorization": "Bearer \(token)"]
                
                do {
                    let _: () = try await deletionService.deleteData(urlString: api, headers: headers)
                    if isPersonalData {
                        currentUserQuestions()
                    }
                } catch {
                    if case NetworkError.statusCodeError(statusCode: let statusCode) = error, statusCode == 401 {
                        try await tokenNetwork.getNewToken()
                        token = try keyService.retrieveAccessToken()
                        headers = ["Authorization": "Bearer \(token)"]
                        
                        let _: () = try await deletionService.deleteData(urlString: api, headers: headers)
                    }
                }
            }catch {
                handleNetworkError(error)
            }
        }
    }
}
