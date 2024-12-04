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
    private var token = ""
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
                token = try keyService.retrieveAccessToken()
                print("✅ Token Retrieved: \(token)")
                
                let headers = ["Authorization": "Bearer \(token)"]
                try await fetchProfileData(api: api, headers: headers)
            } catch {
                if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                    print("⚠️ Token expired, attempting to renew...")
                    await tokenNetwork.renewTokenAndRetry(api: api, retryFunction: fetchProfileData)
                } else {
                    print("❌ Failed to fetch data: \(error.localizedDescription)")
                    handleNetworkError(error)
                }
            }
        }
    }
    
    private func fetchProfileData(api: String, headers: [String: String]) async throws {
        let fetchedData: ProfileModel = try await webService.fetchData(urlString: api, headers: headers)
        profileInfo = fetchedData
        
        DispatchQueue.main.async { [weak self] in
            self?.userInfoDelegate?.didUserInfoFetched()
        }
    }
    
    func fetchedAvatars(api: String){
        Task {
            do {
                token = try keyService.retrieveAccessToken()
                print("✅ Token Retrieved: \(token)")
                
                let headers = ["Authorization": "Bearer \(token)"]
                try await getAvatars(api: api, headers: headers)
            } catch {
                if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                    print("⚠️ Token expired, attempting to renew...")
                    await tokenNetwork.renewTokenAndRetry(api: api, retryFunction: getAvatars)
                } else {
                    print("❌ Failed to fetch data: \(error.localizedDescription)")
                    handleNetworkError(error)
                }
            }
        }
    }
    
    private func getAvatars(api: String, headers: [String: String]) async throws {
        let fetchedAvatars: [Avatar] = try await webService.fetchData(urlString: api, headers: headers)
        avatarsArray = fetchedAvatars
    }
    
    
    private func sendAvatarToDb(name: String, headers: [String : String]) async throws {
        let url = "https://stayconnected.lol/api/user/profile/3/"
        let body = AvatarReqBodyModel(avatarId: name )
        print(body)
        Task {
            do {
                let response: AvatarReqBodyModel = try await putService.putData(urlString: url, headers: headers, body: body)
                print("------------")
                print(response)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func postedAvatar(name: String){
        print(name)
        Task {
            do {
                token = try keyService.retrieveAccessToken()
                print("✅ Token Retrieved: \(token)")
                
                let headers = ["Authorization": "Bearer \(token)"]
                try await sendAvatarToDb(name: name, headers: headers)
                print(headers)
            } catch {
                if case NetworkError.statusCodeError(let statusCode) = error, statusCode == 401 {
                    print("⚠️ Token expired, attempting to renew...")
                    await tokenNetwork.renewTokenAndRetry(api: "", retryFunction: sendAvatarToDb)
                } else {
                    print("❌ Failed to fetch data: \(error.localizedDescription)")
                    handleNetworkError(error)
                }
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
}

