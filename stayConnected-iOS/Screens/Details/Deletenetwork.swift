//
//  Deletenetwork.swift
//  stayConnected-iOS
//
//  Created by Despo on 06.12.24.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case httpResponseError
    case statusCodeError(statusCode: Int)
    case noData
    case decodeError(error: Error)
}

@available(iOS 15, macOS 12.0, *)
public protocol DeleteMethodPorotocol {
    func deleteData(urlString: String, headers: [String: String]?) async throws
}

public final class DeletionService: DeleteMethodPorotocol {
    
    public init() { }
    
    @available(iOS 15, macOS 12.0, *)
    public func deleteData(urlString: String, headers: [String: String]? = nil) async throws {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpResponseError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCodeError(statusCode: httpResponse.statusCode)
        }
    }
}
