//
//  CommentCell.swift
//  stayConnected-iOS
//
//  Created by Despo on 02.12.24.
//

import UIKit
import izziDateFormatter

class CommentCell: UITableViewCell {
    private let izziDateFormatter: IzziDateFormatterProtocol
    
    private lazy var sapcer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 30, right: 0)
        return stack
    }()
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var userInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 5
        return stack
    }()
    
    private lazy var nameDateStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var commentDate: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var commentBody: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var accepted: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.configureCustomText(
            text: "Accepted ✓",
            color: .primaryViolet,
            size: 13,
            weight: .bold
        )
        return label
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        self.izziDateFormatter = IzziDateFormatter()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?,
        izziDateFormatter: IzziDateFormatterProtocol
    ) {
        self.izziDateFormatter = izziDateFormatter
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .primaryWhite
        contentView.addSubview(mainStack)
        mainStack.addArrangedSubview(userInfoStack)
        userInfoStack.addArrangedSubview(avatarImage)
        userInfoStack.addArrangedSubview(nameDateStack)
        userInfoStack.addArrangedSubview(sapcer)
        userInfoStack.addArrangedSubview(accepted)
        nameDateStack.addArrangedSubview(userName)
        nameDateStack.addArrangedSubview(commentDate)
        mainStack.addArrangedSubview(commentBody)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            avatarImage.widthAnchor.constraint(equalToConstant: 40),
            avatarImage.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configureCell(with answer: Answer) {
        userName.configureCustomText(
            text: answer.user.firstName,
            color: .primaryBack,
            size: 15,
            weight: .bold
        )
        
        avatarImage.image = UIImage(named: "\(answer.user.avatar ?? "testUser")")
        
        let date = izziDateFormatter.isoTimeFormatter(
            currentDate: answer.createDate,
            finalFormat: "EEEE, d MMM yyyy",
            timeZoneOffset: 4
        )
        
        commentDate.configureCustomText(
            text: date,
            color: .primaryBack,
            size: 12,
            weight: .thin
        )
        
        commentBody.configureCustomText(
            text: answer.text,
            color: .primaryGray,
            size: 15,
            weight: .regular
        )
        
        accepted.isHidden = answer.isCorrect ? false : true
    }
}
