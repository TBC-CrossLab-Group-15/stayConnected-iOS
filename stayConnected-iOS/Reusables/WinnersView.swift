//
//  WinnersView.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class WinnersView: UIView {
    var colorForBorder: UIColor
    var imageUrl: String
    var positionIcon: String
    var firstName: String
    var score: Int
    var userName: String
    
    private lazy var winStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .fill
        stack.alignment = .center
        return stack
    }()
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        image.layer.borderWidth = 1
        image.layer.borderColor = colorForBorder.cgColor
        return image
    }()
    
    private lazy var positionImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: positionIcon)
        
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: firstName,
            color: .primaryWhite,
            size: 12,
            weight: .semibold
        )
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "\(score)",
            color: .primaryWhite,
            size: 15,
            weight: .bold
        )
        return label
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "@\(userName)",
            color: .primaryWhite,
            size: 10,
            weight: .bold
        )
        return label
    }()
    
    init(
        colorForBorder: UIColor,
        imageUrl: String,
        positionIcon: String,
        firstName: String,
        score: Int,
        userName: String
    ) {
        self.colorForBorder = colorForBorder
        self.imageUrl = imageUrl
        self.positionIcon = positionIcon
        self.firstName = firstName
        self.score = score
        self.userName = userName
        super.init(frame: .zero)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        
        addSubview(winStack)
        winStack.addArrangedSubview(avatarImage)
        winStack.addArrangedSubview(positionImage)
        winStack.addArrangedSubview(nameLabel)
        winStack.addArrangedSubview(scoreLabel)
        winStack.addArrangedSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            winStack.topAnchor.constraint(equalTo: topAnchor),
            winStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            winStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            winStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            avatarImage.widthAnchor.constraint(equalToConstant: 60),
            avatarImage.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        avatarImage.image = UIImage(named: imageUrl)
        avatarImage.backgroundColor = colorForBorder
    }
    
}
