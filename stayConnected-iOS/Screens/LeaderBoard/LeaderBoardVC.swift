//
//  LeaderBoardVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class LeaderBoardVC: UIViewController {
    
    let arr = ["12", "12", "12","12", "12", "12","12", "12", "12","12"]
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Liderboard",
            color: .black,
            fontName: "InterB",
            size: 20
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
        imageUrl: "https://picsum.photos/200",
        positionIcon: "firsPositionIcon",
        firstName: "leon",
        score: 34,
        userName: "johnatn"
    )
    
    private let thirdPlace = WinnersView(
        colorForBorder: .thirdPlaceBorder,
        imageUrl: "https://picsum.photos/200",
        positionIcon: "thirdPlaceIcon",
        firstName: "leon",
        score: 34,
        userName: "johnatn"
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupUI()
    }
    
    private func setupUI(){
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
}

extension LeaderBoardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as? BoardCell
        let singleCell = arr[indexPath.row]
        cell?.configureCell(with: singleCell)
        cell?.selectionStyle = .none
        return cell ?? BoardCell()
    }
    
   
}
