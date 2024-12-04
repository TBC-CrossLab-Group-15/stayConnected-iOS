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

protocol TagsModelDelegate: AnyObject {
    func didTagsFetched()
}

final class FeedViewModel {
    private var pageCount = 0
    private var totalCount = 0
    private let tagApiLink = "https://stayconnected.lol/api/posts/tags/"
    weak var delegate: FeedModelDelegate?
    weak var tagsDelegate: TagsModelDelegate?
    
    private let webService: NetworkServiceProtocol
    
    private var questionsArray: [QuestionModel] = []
    
    var tagsArray: [Tag] = []
    
    init(webService: NetworkServiceProtocol = NetworkService()) {
        self.webService = webService
        fetchTagsData(api: tagApiLink)
        updatePages()
    }
    
    private func fetchData(api: String) {
        Task {
            do {
                let fetchedData: QuestionsResponse = try await webService.fetchData(urlString: api, headers: [:])
                questionsArray = fetchedData.results
                totalCount = fetchedData.count
                print(totalCount)
//                print(fetchedData)
                questionsArray.append(contentsOf: fetchedData.results)
                DispatchQueue.main.async {[weak self] in
                    self?.delegate?.didDataFetched()
                }
            } catch {
                handleNetworkError(error)
            }
        }
    }
    
    private func fetchTagsData(api: String) {
        Task {
            do {
                let fetchedData: [Tag] = try await webService.fetchData(urlString: api, headers: [:])
                tagsArray = fetchedData
                DispatchQueue.main.async {[weak self] in
                    self?.tagsDelegate?.didTagsFetched()
                }
            } catch {
                handleNetworkError(error)
            }
        }
    }
    
    var questionsCount: Int {
        questionsArray.count
    }
    
    func singleQuestion(with index: Int) -> QuestionModel {
        questionsArray[index]
    }
    
    func singleTag(whit index: Int) -> Tag {
        tagsArray[index]
    }
    
    func fetchDataWithTag(with tagName: String) {
        let apiLink = "http://localhost:3000/feed/\(tagName)"
        fetchData(api: apiLink)
    }
    
    func updatePages() {
        if pageCount <= totalCount {
            pageCount += 5
            let apiLink = "https://stayconnected.lol/api/posts/questions/?page=1&page_size=\(pageCount)"
            fetchData(api: apiLink)
        }
    }
}
