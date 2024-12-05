//
//  LeaderBoardVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class LeaderBoardVC: UIViewController, LeaderBoardDelegate {
    private let viewModel: LeaderBoardViewModel
        
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Liderboard",
            color: .black,
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
    
    private let secondPlace = WinnersView(
        colorForBorder: .primaryGray,
        imageUrl: "https://picsum.photos/200",
        positionIcon: "secondPlaceIcon",
        firstName: "leon",
        score: 34,
        userName: "johnatn"
    )
    
    private let firstPlace = WinnersView(
        colorForBorder: .firsPlaceBorder,
        imageUrl: "",
        positionIcon: "",
        firstName: "",
        score: 0,
        userName: ""
    )
    
    private let thirdPlace = WinnersView(
        colorForBorder: .thirdPlaceBorder,
        imageUrl: "https://picsum.photos/200",
        positionIcon: "thirdPlaceIcon",
        firstName: "leon",
        score: 34,
        userName: "johnatn"
    )
    
    init(
        viewModel: LeaderBoardViewModel = LeaderBoardViewModel()
    ) {
        self.viewModel = viewModel
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
        
        view.backgroundColor = .white
        view.addSubview(screenTitle)
        view.addSubview(horizonatlView)
        view.addSubview(verticalView)
        view.addSubview(boardView)
        boardView.addSubview(leadBoardTabel)
        
        secondPlace.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondPlace)
        
        firstPlace.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstPlace)
        
        thirdPlace.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thirdPlace)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            screenTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            secondPlace.leadingAnchor.constraint(equalTo: horizonatlView.leadingAnchor, constant: 20),
            secondPlace.bottomAnchor.constraint(equalTo: horizonatlView.bottomAnchor, constant: -10),
            
            firstPlace.centerXAnchor.constraint(equalTo: verticalView.centerXAnchor),
            firstPlace.bottomAnchor.constraint(equalTo: horizonatlView.bottomAnchor, constant: -40),
            
            thirdPlace.trailingAnchor.constraint(equalTo: horizonatlView.trailingAnchor, constant: -20),
            thirdPlace.bottomAnchor.constraint(equalTo: horizonatlView.bottomAnchor, constant: -10),
            
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
        ])
    }
    
    func didBoardFetched() {
        self.leadBoardTabel.reloadData()

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let firstUser = self.viewModel.getSingleUser(at: 1)
            print("🦧")
            self.firstPlace.firstName = firstUser.firstName
            self.firstPlace.userName = firstUser.lastName
            self.firstPlace.score = firstUser.rating

            self.firstPlace.setNeedsDisplay()
            self.firstPlace.layoutIfNeeded()
        }
    }

}

extension LeaderBoardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.leaderBoardArray.count)
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
