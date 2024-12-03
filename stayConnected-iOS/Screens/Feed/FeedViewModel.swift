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
    private var apiLink = "http://localhost:3000/feed"
    private let tagApiLink = "https://stayconnected.lol/api/posts/tags/"
    weak var delegate: FeedModelDelegate?
    weak var tagsDelegate: TagsModelDelegate?

    private let webService: NetworkServiceProtocol
    
    private var questionsArray: [QuestionModel] = []
    
    var tagsArray: [Tag] = []
    
    init(webService: NetworkServiceProtocol = NetworkService()) {
        self.webService = webService
        fetchData(api: apiLink)
        fetchTagsData(api: tagApiLink)
    }
    
    private func fetchData(api: String) {
            Task {
                do {
                    let fetchedData: [QuestionModel] = try await webService.fetchData(urlString: api, headers: [:])
                    questionsArray = fetchedData
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
    
    private func handleNetworkError(_ error: Error) {
            switch error {
            case NetworkError.httpResponseError:
                print("Response is not HTTPURLResponse or missing")
            case NetworkError.invalidURL:
                print("Invalid URL")
            case NetworkError.statusCodeError(let statusCode):
                print("Unexpected status code: \(statusCode)")
            case NetworkError.noData:
                print("No data received from server")
            case NetworkError.decodeError(let error):
                print("Decode error: \(error.localizedDescription)")
            default:
                print("Unexpected error: \(error.localizedDescription)")
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
        apiLink = "http://localhost:3000/feed/\(tagName)"
        fetchData(api: apiLink)
        print(apiLink)
    }
}
