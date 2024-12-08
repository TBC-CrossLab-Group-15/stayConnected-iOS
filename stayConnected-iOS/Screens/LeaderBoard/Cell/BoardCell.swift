//
//  BoardCell.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

class BoardCell: UITableViewCell {
    private lazy var spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .bgWhite
        return view
    }()
    
    private lazy var dividerSpace: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 5
        stack.clipsToBounds = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stack.layer.cornerRadius = 12
        return stack
    }()
    
    private lazy var leftStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 1
        return stack
    }()
    
    private lazy var userAvatar: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var score: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .bgWhite
        contentView.addSubview(mainStack)
        mainStack.addArrangedSubview(userAvatar)
        mainStack.addArrangedSubview(leftStack)
        leftStack.addArrangedSubview(nameLabel)
        leftStack.addArrangedSubview(userNameLabel)
        mainStack.addArrangedSubview(dividerSpace)
        mainStack.addArrangedSubview(score)
        
        contentView.addSubview(spacer)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userAvatar.widthAnchor.constraint(equalToConstant: 50),
            userAvatar.heightAnchor.constraint(equalToConstant: 50),
            
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            spacer.heightAnchor.constraint(equalToConstant: 24),
            spacer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            spacer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            spacer.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 0),
            spacer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }
    
    func configureCell(with user: LeaderBoardModel) {
        nameLabel.text = "Name: \(user.firstName)"
        userNameLabel.text = "@\(user.lastName)"
        score.text = "Score: \(user.rating)"
        userAvatar.image = UIImage(named: user.avatar ?? "testUser")
    }
}
