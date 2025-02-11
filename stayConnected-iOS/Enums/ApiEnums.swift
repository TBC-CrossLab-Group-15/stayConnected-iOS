//
//  ApiEnums.swift
//  stayConnected-iOS
//
//  Created by Despo on 11.02.25.
//

enum EndpointsEnum: String {
  case register = "https://staycon.otter.ge/api/user/register/"
  case logout = "https://staycon.otter.ge/api/user/logout/"
  case login = "https://staycon.otter.ge/api/user/login/"
  case token = "https://staycon.otter.ge/api/user/token/refresh/"
  case answers = "https://staycon.otter.ge/api/posts/answers/"
  case singelQuestion = "https://staycon.otter.ge/api/posts/questions/"
  case feed = "https://staycon.otter.ge/api/posts/questions"
  case tags = "https://staycon.otter.ge/api/posts/tags/"
  case search = "https://staycon.otter.ge/api/posts/search/?search"
  case currentQuestion = "https://staycon.otter.ge/api/user/currentuserquestions/"
  case profile = "https://staycon.otter.ge/api/user/profile/"
  case currentUser = "https://staycon.otter.ge/api/user/currentuser/"
  case avatars = "https://staycon.otter.ge/api/user/avatars/"
  case leaderboard = "https://staycon.otter.ge/api/user/leaderboard/"
}
