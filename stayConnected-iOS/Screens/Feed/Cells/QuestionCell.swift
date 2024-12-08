//
//  QuestionCell.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class QuestionCell: UITableViewCell {
    
    private var tagsArray: [Tag] = []
    
    private lazy var questionTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var repCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var checkMark: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "checkMark")
        return image
    }()
    
    private lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        
        return stack
    }()
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var tagCollection: UICollectionView = {
            let collection: UICollectionView
            let collectionLayout = UICollectionViewFlowLayout()
            collectionLayout.scrollDirection = .horizontal
        collectionLayout.estimatedItemSize = CGSize(width: 100, height: 30)
            collectionLayout.minimumInteritemSpacing = 8
            collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.register(QuestionSingleTagCell.self, forCellWithReuseIdentifier: "QuestionSingleTagCell")
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.dataSource = self
            collection.showsHorizontalScrollIndicator = false
            return collection
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
        contentView.addSubview(cellStack)
        cellStack.addArrangedSubview(cellView)
        cellView.addSubview(questionTitle)
        cellView.addSubview(questionLabel)
        cellView.addSubview(repCountLabel)
        cellView.addSubview(checkMark)
        cellView.addSubview(tagCollection)
        
        NSLayoutConstraint.activate([
            cellStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            cellView.leadingAnchor.constraint(equalTo: cellStack.leadingAnchor, constant: 0),
            cellView.trailingAnchor.constraint(equalTo: cellStack.trailingAnchor, constant: 0),
            cellView.topAnchor.constraint(equalTo: cellStack.topAnchor, constant: 0),
            cellView.bottomAnchor.constraint(equalTo: cellStack.bottomAnchor, constant: 0),
            cellView.heightAnchor.constraint(equalToConstant: 125),
            
            questionTitle.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            questionTitle.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16),
            questionTitle.widthAnchor.constraint(equalToConstant: 150),
            
            questionLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            questionLabel.topAnchor.constraint(equalTo: questionTitle.bottomAnchor, constant: 2),
            questionLabel.widthAnchor.constraint(equalToConstant: 200),
            
            repCountLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
            repCountLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 14),
            
            checkMark.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -19),
            checkMark.topAnchor.constraint(equalTo: repCountLabel.bottomAnchor, constant: 14),
            
            tagCollection.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            tagCollection.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 0),
            tagCollection.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 16),
            tagCollection.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10),
        ])
    }
    
    func configureCell(with question: QuestionModel) {
        tagsArray = question.tags

        questionTitle.configureCustomText(
            text: "\(question.user.firstName) \(question.user.lastName)",
            color: .primaryGray,
            size: 13,
            weight: .regular,
            lineNumber: 1
        )
        
        questionLabel.configureCustomText(
            text: question.title,
            color: .primaryBack,
            size: 18,
            weight: .regular,
            lineNumber: 1
        )
        
        repCountLabel.configureCustomText(
            text: "replies: \(question.answers.count)",
            color: .primaryGray,
            size: 15,
            weight: .regular
        )
        repCountLabel.font = UIFont.italicSystemFont(ofSize: 11)
        
        if question.answers.count > 0 {
            checkMark.isHidden = question.answers[0].isCorrect ? false : true
        } else {
            checkMark.isHidden = true
        }
        tagCollection.reloadData()
    }
}

extension QuestionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionSingleTagCell", for: indexPath) as? QuestionSingleTagCell
        
        let singleTag = tagsArray[indexPath.row]
        
        cell?.setupCell(with: singleTag)
        return cell ?? QuestionSingleTagCell()
    }
}
