//
//  TagCell.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class TagCell: UICollectionViewCell {
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
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        contentView.addSubview(cellStack)
        cellStack.addArrangedSubview(tagLabel)
        contentView.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellStack.heightAnchor.constraint(equalToConstant: 28),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: Tag) {
        tagLabel.configureCustomText(
            text: model.name,
            color: .primaryViolet,
            size: 14,
            weight: .regular,
            lineNumber: 1
        )
    }
    
    func configureWithName(with tagName: String) {
        tagLabel.configureCustomText(
            text: tagName,
            color: .primaryViolet,
            size: 14,
            weight: .bold,
            lineNumber: 1
        )
    }
}
