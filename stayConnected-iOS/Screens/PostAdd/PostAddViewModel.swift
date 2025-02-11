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
  }
  
  func fetchTags(api: String) {
    Task {
      
      var token = try keyService.retrieveAccessToken()
      var headers = ["Authorization": "Bearer \(token)"]
      
      do {
        let fetchedData: [Tag] = try await webService.fetchData(urlString: api, headers: [:])
        inactiveTags = fetchedData
        await MainActor.run {
          delegate?.didTagsRefreshed()
        }
      } catch {
        if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
          try await tokenNetwork.getNewToken()
          token = try keyService.retrieveAccessToken()
          
          headers = ["Authorization": "Bearer \(token)"]
          
          let fetchedData: [Tag] = try await webService.fetchData(urlString: api, headers: headers)
          inactiveTags = fetchedData
          await MainActor.run {
            delegate?.didTagsRefreshed()
          }
          
        } else {
          handleNetworkError(error)
        }
      }
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
  
  func attemptAddQuestion(api: String, subject: String, question: String) {
    let tagIds = activeTags.map { $0.id }
    let body = PostModel(title: subject, text: question, tags: tagIds)
    
    Task {
      do {
        var token = try keyService.retrieveAccessToken()
        var headers = ["Authorization": "Bearer \(token)"]
        
        do {
          try await postQuestion(api: api, headers: headers, body: body)
          
        } catch {
          if case NetworkError.statusCodeError(statusCode: let statusCode) = error, statusCode == 401 {
            
            try await tokenNetwork.getNewToken()
            token = try keyService.retrieveAccessToken()
            headers = ["Authorization": "Bearer \(token)"]
            
            try await postQuestion(api: api, headers: headers, body: body)
            
          } else {
            throw error
          }
        }
      } catch {
        handleNetworkError(error)
        await MainActor.run {
          postingFailure?.didPostingFailed()
        }
      }
    }
  }
  
  func postQuestion(api: String, headers: [String : String], body: PostModel) async throws {
    let _ : PostModelResponse = try await postService.postData(
      urlString: api,
      headers: headers,
      body: body
    )
    await MainActor.run {
      delegate?.didTagsRefreshed()
      successDelegate?.didPostAddedSuccssfully()
    }
  }
}
