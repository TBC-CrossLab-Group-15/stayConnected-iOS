//
//  AvatarCell.swift
//  stayConnected-iOS
//
//  Created by Despo on 01.12.24.
//

import UIKit

class AvatarCell: UITableViewCell {
    private lazy var avatarName = UILabel()

    private lazy var spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.backgroundColor = .bgWhite
        contentView.addSubview(cellStack)
        cellStack.addArrangedSubview(avatarImage)
        cellStack.addArrangedSubview(avatarName)
        cellStack.addArrangedSubview(spacer)
        avatarImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 50).isActive = true

        NSLayoutConstraint.activate([
            cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cellStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cellStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    func configureCell(with avatar: String) {
        avatarImage.image = UIImage(named: avatar)
        avatarName.configureCustomText(
            text: avatar,
            color: .primaryBack,
            size: 16,
            weight: .bold
        )
    }

}
