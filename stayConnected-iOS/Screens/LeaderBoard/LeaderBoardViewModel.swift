//
//  LeaderBoardViewModel.swift
//  stayConnected-iOS
//
//  Created by Despo on 05.12.24.
//

import NetworkManagerFramework
import Foundation

protocol LeaderBoardDelegate: AnyObject {
  func didBoardFetched()
}

final class LeaderBoardViewModel {
  private let webService: NetworkServiceProtocol
  var leaderBoardArray: [LeaderBoardModel] = []
  weak var delegate: LeaderBoardDelegate?
  
  init(
    webService: NetworkServiceProtocol = NetworkService()
  ) {
    self.webService = webService
  }
  
  func fetchLeaderBoard() {
    let apiLink = EndpointsEnum.leaderboard.rawValue
    
    Task {
      do {
        let response: [LeaderBoardModel] = try await webService.fetchData(urlString: apiLink, headers: nil)
        leaderBoardArray = response
        await MainActor.run {
          delegate?.didBoardFetched()
        }
      } catch {
        handleNetworkError(error)
      }
    }
  }
  
  func getSingleUser(at index: Int) -> LeaderBoardModel {
    leaderBoardArray[index]
  }
}
