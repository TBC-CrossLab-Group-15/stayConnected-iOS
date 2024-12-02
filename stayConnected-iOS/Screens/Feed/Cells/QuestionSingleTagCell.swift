//
//  QuestionSingleTagCell.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class QuestionSingleTagCell: UICollectionViewCell {
    private lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 1, left: 12, bottom: 1, right: 12)
        stack.backgroundColor = .tagBG
        stack.clipsToBounds = true
        stack.layer.cornerRadius = 12
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var tagButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        contentView.addSubview(cellStack)
        cellStack.addArrangedSubview(tagButton)
        contentView.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellStack.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupCell(with tag: Tag) {
        tagButton.setTitle(tag.name, for: .normal)
        tagButton.setTitleColor(.primaryViolet, for: .normal)
    }
}
