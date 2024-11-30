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

final class FeedViewModel {
    weak var delegate: FeedModelDelegate?
    private let webService: NetworkServiceProtocol
    
    private var questionsArray: [QuestionModel] = []
    
    private var tagsArray = [
        TagModel(name: "swift", endPoint: "/"),
        TagModel(name: "iOS", endPoint: "/"),
        TagModel(name: "react", endPoint: "/"),
        TagModel(name: "js", endPoint: "/"),
        TagModel(name: "figma", endPoint: "/"),
        TagModel(name: "android", endPoint: "/"),
        TagModel(name: "tvOS", endPoint: "/"),
    ]
    
    init(webService: NetworkServiceProtocol = NetworkService()) {
        self.webService = webService
        fetchdata()
    }
    
    private func fetchdata() {
        let apiLink = "http://localhost:3000/feed"
        
        Task {
            do {
                let fetchedData: QuestionsResponse = try await webService.fetchData(urlString: apiLink, headers: [:])
                questionsArray = fetchedData.response
                DispatchQueue.main.async {[weak self] in
                    self?.delegate?.didDataFetched()
                }
            } catch NetworkError.httpResponseError {
                print("Response is not HTTPURLResponse or missing")
            } catch NetworkError.invalidURL {
                print("Invalid URL")
            } catch NetworkError.statusCodeError(let statusCode) {
                print("Unexpected status code: \(statusCode)")
            } catch NetworkError.noData {
                print("No data received from server")
            } catch NetworkError.decodeError(let error) {
                print("Decode error: \(error.localizedDescription)")
            } catch {
                print("Unexpected error: \(error.localizedDescription)")
            }
        }
    }
    
    var tagsCount: Int {
        tagsArray.count
    }
    
    var questionsCount: Int {
        questionsArray.count
    }
    
    func singleQuestion(with index: Int) -> QuestionModel {
        questionsArray[index]
    }
    
    func singleTag(whit index: Int) -> TagModel {
        tagsArray[index]
    }
}
