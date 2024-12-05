//
//  KeyChain.swift
//  stayConnected-iOS
//
//  Created by Despo on 03.12.24.
//
import SimpleKeychain
import NetworkManagerFramework

protocol TokenRetrieveProtocol {
    func retrieveRefreshToken() throws -> String
    func storeAccessTokens(access: String) throws
    func retrieveAccessToken() throws -> String
}

final class KeychainService: TokenRetrieveProtocol {
    let keyService: SimpleKeychain
    
    init(keyService: SimpleKeychain = SimpleKeychain()) {
        self.keyService = keyService
    }
    
    func storeTokens(access: String, refresh: String) throws {
        try keyService.set(access, forKey: "accessToken")
        try keyService.set(refresh, forKey: "refreshToken")
    }
    
    func storeUserID(userID: String) throws {
        try keyService.set(userID, forKey: "userID")
    }
    
    func retrieveUserID() throws -> String{
        try keyService.string(forKey: "userID")
    }
    
    func storeAccessTokens(access: String) throws {
        try keyService.set(access, forKey: "accessToken")
    }
    
    func retrieveAccessToken() throws -> String{
        try keyService.string(forKey: "accessToken")
    }
    
    func retrieveRefreshToken() throws -> String{
        try keyService.string(forKey: "refreshToken")
    }
    
    func checkAccessToken() throws -> Bool {
        try keyService.hasItem(forKey: "accessToken")
    }
    
    func checkRefreshToken() throws -> Bool {
        try keyService.hasItem(forKey: "refreshToken")
    }
    
    func removeTokens() throws {
        try keyService.deleteItem(forKey: "accessToken")
        try keyService.deleteItem(forKey: "refreshToken")
    }
}
