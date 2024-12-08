//
//  LeaderBoardVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class LeaderBoardVC: UIViewController, LeaderBoardDelegate {
    private let viewModel: LeaderBoardViewModel
    private let loadingIndicator: LoadingIndicator
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "LeaderBoard",
            color: .primaryBack,
            size: 20,
            weight: .bold
        )
        return label
    }()
    
    private lazy var horizonatlView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryViolet
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var verticalView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryViolet
        view.clipsToBounds = true
        view.layer.cornerRadius = 24
        return view
    }()
    
    private lazy var leadBoardTabel: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(BoardCell.self, forCellReuseIdentifier: "BoardCell")
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var boardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .bgWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    init(
        viewModel: LeaderBoardViewModel = LeaderBoardViewModel(),
        loadingIndicator: LoadingIndicator = LoadingIndicator()
    ) {
        self.viewModel = viewModel
        self.loadingIndicator = loadingIndicator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupUI()
    }
    
    private func setupUI(){
        viewModel.delegate = self
        viewModel.fetchLeaderBoard()
        
        view.backgroundColor = .primaryWhite
        view.addSubview(screenTitle)
        view.addSubview(horizonatlView)
        view.addSubview(verticalView)
        view.addSubview(boardView)
        boardView.addSubview(leadBoardTabel)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        view.bringSubviewToFront(loadingIndicator)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()

        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            screenTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            horizonatlView.heightAnchor.constraint(equalToConstant: 120),
            horizonatlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            horizonatlView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            
            verticalView.heightAnchor.constraint(equalToConstant: 152),
            verticalView.widthAnchor.constraint(equalToConstant: 112),
            verticalView.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 64),
            verticalView.centerXAnchor.constraint(equalTo: horizonatlView.centerXAnchor),
            verticalView.bottomAnchor.constraint(equalTo: horizonatlView.bottomAnchor, constant: 0),
            
            boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            boardView.topAnchor.constraint(equalTo: verticalView.bottomAnchor, constant: 18),
            boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            boardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -9),
            
            leadBoardTabel.leadingAnchor.constraint(equalTo: boardView.leadingAnchor, constant: 16),
            leadBoardTabel.topAnchor.constraint(equalTo: boardView.topAnchor, constant: 16),
            leadBoardTabel.trailingAnchor.constraint(equalTo: boardView.trailingAnchor, constant: -16),
            leadBoardTabel.bottomAnchor.constraint(equalTo: boardView.bottomAnchor, constant: -16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func didBoardFetched() {
        self.leadBoardTabel.reloadData()
        
        guard viewModel.leaderBoardArray.count >= 3 else { return }
        let board = viewModel.leaderBoardArray
        
        let firstPlace = WinnersView(
            colorForBorder: .firsPlaceBorder,
            imageUrl: board[0].avatar ?? "testUser",
            positionIcon: "firsPositionIcon",
            firstName: board[0].firstName,
            score: board[0].rating,
            userName: board[0].lastName
        )
        
        let secondPlace = WinnersView(
            colorForBorder: .primaryGray,
            imageUrl: board[1].avatar ?? "testUser",
            positionIcon: "secondPlaceIcon",
            firstName: board[1].firstName,
            score: board[1].rating,
            userName: board[1].lastName
        )
        
        let thirdPlace = WinnersView(
            colorForBorder: .primaryGray,
            imageUrl: board[2].avatar ?? "testUser",
            positionIcon: "thirdPlaceIcon",
            firstName: board[2].firstName,
            score: board[2].rating,
            userName: board[2].lastName
        )
        
        view.addSubview(firstPlace)
        view.addSubview(secondPlace)
        view.addSubview(thirdPlace)
        
        firstPlace.translatesAutoresizingMaskIntoConstraints = false
        secondPlace.translatesAutoresizingMaskIntoConstraints = false
        thirdPlace.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondPlace.leadingAnchor.constraint(equalTo: horizonatlView.leadingAnchor, constant: 20),
            secondPlace.bottomAnchor.constraint(equalTo: horizonatlView.bottomAnchor, constant: -20),
            
            firstPlace.centerXAnchor.constraint(equalTo: verticalView.centerXAnchor),
            firstPlace.bottomAnchor.constraint(equalTo: horizonatlView.bottomAnchor, constant: -50),
            
            thirdPlace.trailingAnchor.constraint(equalTo: horizonatlView.trailingAnchor, constant: -20),
            thirdPlace.bottomAnchor.constraint(equalTo: horizonatlView.bottomAnchor, constant: -20)
        ])
        
        loadingIndicator.stopAnimating()
    }
}

extension LeaderBoardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.leaderBoardArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as? BoardCell
        let currentUser = viewModel.getSingleUser(at: indexPath.row)
        cell?.configureCell(with: currentUser)
        cell?.selectionStyle = .none
        return cell ?? BoardCell()
    }
    
    
}
