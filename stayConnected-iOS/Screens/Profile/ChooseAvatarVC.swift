//
//  ChooseAvatarVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 01.12.24.
//

import UIKit

class ChooseAvatarVC: UIViewController {
    private let viewModel: ProfileViewModel
    
    private lazy var avatarsTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AvatarCell.self, forCellReuseIdentifier: "AvatarCell")
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgWhite
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 12
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    init(viewModel: ProfileViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(avatarsTable)
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .primaryWhite
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarsTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            avatarsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            avatarsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}

extension ChooseAvatarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.avatarsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarCell", for: indexPath) as? AvatarCell
        let currentAvatar = viewModel.singleAvatar(at: indexPath.row)
        cell?.selectionStyle = .none
        cell?.configureCell(with: currentAvatar.name)
        return cell ?? AvatarCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAvatar = viewModel.singleAvatar(at: indexPath.row)
        viewModel.setAvatar(with: currentAvatar.name)
        viewModel.postedAvatar(name: currentAvatar.name)
    }
}
