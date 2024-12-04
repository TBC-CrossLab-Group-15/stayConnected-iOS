//
//  Network.swift
//  stayConnected-iOS
//
//  Created by Despo on 04.12.24.
//
import NetworkManagerFramework

public func handleNetworkError(_ error: Error) {
    switch error {
    case NetworkError.httpResponseError:
        print("❌ Response is not HTTPURLResponse or missing")
    case NetworkError.invalidURL:
        print("❌ Invalid URL")
    case NetworkError.statusCodeError(let statusCode):
        print("❌ Unexpected status code: \(statusCode)")
    case NetworkError.noData:
        print("❌ No data received from server")
    case NetworkError.decodeError(let decodeError):
        print("❌ Decode error: \(decodeError.localizedDescription)")
    default:
        print("❌ Unexpected error: \(error.localizedDescription)")
    }
}
