//
//  ProfileViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 01.12.24.
//

import Foundation
import NetworkManagerFramework

protocol AvatarDelegate: AnyObject {
  func didAvatarChanged()
}

protocol UserInfoDelegate: AnyObject {
  func didUserInfoFetched()
}

final class ProfileViewModel {
  weak var delegate: AvatarDelegate?
  weak var userInfoDelegate: UserInfoDelegate?
  
  private let keyService: KeychainService
  private let webService: NetworkServiceProtocol
  private let postService: PostServiceProtocol
  private let putService: PutServiceProtocol
  
  private let tokenNetwork: TokenNetwork
  var profileInfo: ProfileModel?
  var avatarName: String = ""
  
  private var avatarsArray: [Avatar] = []
  
  init(
    webService: NetworkServiceProtocol = NetworkService(),
    keyService: KeychainService = KeychainService(),
    tokenNetwork: TokenNetwork = TokenNetwork(),
    postService: PostServiceProtocol = PostService(),
    putService: PutServiceProtocol = PutService()
  ) {
    self.webService = webService
    self.keyService = keyService
    self.tokenNetwork = tokenNetwork
    self.postService = postService
    self.putService = putService
  }
  
  func fetchData(api: String) {
    Task {
      do {
        var token = try keyService.retrieveAccessToken()
        var headers = ["Authorization": "Bearer \(token)"]
        
        do {
          try await fetchProfileData(api: api, headers: headers)
        } catch {
          if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
            try await tokenNetwork.getNewToken()
            token = try keyService.retrieveAccessToken()
            headers = ["Authorization": "Bearer \(token)"]
            try await fetchProfileData(api: api, headers: headers)
          } else {
            throw error
          }
        }
      } catch {
        handleNetworkError(error)
      }
    }
  }
  
  private func fetchProfileData(api: String, headers: [String: String]) async throws {
    let fetchedData: ProfileModel = try await webService.fetchData(urlString: api, headers: headers)
    profileInfo = fetchedData
    
    await MainActor.run{
      userInfoDelegate?.didUserInfoFetched()
    }
  }
  
  func fetchedAvatars(api: String){
    Task {
      do {
        var token = try keyService.retrieveAccessToken()
        var headers = ["Authorization": "Bearer \(token)"]
        
        do {
          try await getAvatars(api: api, headers: headers)
        } catch {
          if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
            try await tokenNetwork.getNewToken()
            token = try keyService.retrieveAccessToken()
            headers = ["Authorization": "Bearer \(token)"]
            
            try await getAvatars(api: api, headers: headers)
          } else {
            throw error
          }
        }
      } catch {
        handleNetworkError(error)
      }
    }
  }
  
  private func getAvatars(api: String, headers: [String: String]) async throws {
    let fetchedAvatars: [Avatar] = try await webService.fetchData(urlString: api, headers: headers)
    avatarsArray = fetchedAvatars
  }
  
  private func sendAvatarToDb(name: String, headers: [String : String]) async throws {
    let userID = try keyService.retrieveUserID()
    let url = "\(EndpointsEnum.profile.rawValue)\(userID)/"
    let body = AvatarReqBodyModel(avatarId: name )
    
    let _: AvatarReqBodyModel = try await putService.putData(urlString: url, headers: headers, body: body)
  }
  
  func postedAvatar(name: String){
    Task {
      do {
        var token = try keyService.retrieveAccessToken()
        var headers = ["Authorization": "Bearer \(token)"]
        
        do {
          try await sendAvatarToDb(name: name, headers: headers)
        } catch {
          if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
            try await tokenNetwork.getNewToken()
            
            token = try keyService.retrieveAccessToken()
            headers = ["Authorization": "Bearer \(token)"]
            
            try await sendAvatarToDb(name: name, headers: headers)
          } else {
            throw error
          }
        }
      } catch {
        handleNetworkError(error)
      }
    }
  }
  
  var avatarsCount: Int {
    avatarsArray.count
  }
  
  func singleAvatar(at index: Int) -> Avatar {
    avatarsArray[index]
  }
  
  func setAvatar(with name: String) {
    UserDefaults.standard.set(name, forKey: "userAvatar")
    avatarName = name
    delegate?.didAvatarChanged()
  }
  
  func logOut() throws {
    let api = EndpointsEnum.logout.rawValue
    
    Task {
      do {
        let refreshToken = try keyService.retrieveRefreshToken()
        let body = LogoutModel(refresh: refreshToken)
        
        let _: LogoutModel = try await postService.postData(urlString: api, headers: nil, body: body)
        try keyService.removeTokens()
      } catch {
        handleNetworkError(error)
      }
    }
    
    try keyService.removeTokens()
  }
}

