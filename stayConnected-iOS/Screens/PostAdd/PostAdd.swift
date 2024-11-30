//
//  PostAdd.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

class PostAdd: UIViewController, DidTagsRefreshed, DidTagsRefreshedInactiveTags {
    private let viewModel: PostAddViewModel
    
    private let lineOne:UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .primaryGray
        return lineView
    }()
    
    private let lineTwo:UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .primaryGray
        return lineView
    }()
    
    private let lineThree:UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .primaryGray
        return lineView
    }()
    
    private lazy var headerBar: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Add Question",
            color: .black,
            fontName: "Inter",
            size: 16
        )
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.configureCustomButton(
            title: "Cancel",
            color: .primaryViolet,
            fontName: "InterB",
            fontSize: 16,
            action: closeModal
        )
        return button
    }()
    
    private lazy var subjectInput: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.clipsToBounds = true
        field.keyboardType = .default
        
        // Create left label container
        let leftLabelContainer = UIView()
        leftLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Create left label
        let leftLabel = UILabel()
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.configureCustomText(
            text: "Subject: ",
            color: .primaryGray,
            fontName: "InterR",
            size: 15
        )
        leftLabelContainer.addSubview(leftLabel)
        
        // Add padding
        let padding: CGFloat = 16
        let intrinsicWidth = leftLabel.intrinsicContentSize.width + padding
        
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: leftLabelContainer.leadingAnchor, constant: 8),
            leftLabelContainer.widthAnchor.constraint(equalToConstant: intrinsicWidth),
            leftLabelContainer.heightAnchor.constraint(equalToConstant: 47),
            leftLabel.centerYAnchor.constraint(equalTo: leftLabelContainer.centerYAnchor)
            
        ])
        
        // Assign container to leftView
        field.leftView = leftLabelContainer
        field.leftViewMode = .always
        
        return field
    }()
    
    private lazy var tagInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Tag: ",
            color: .primaryGray,
            fontName: "InterR",
            size: 15
        )
        return label
    }()
    
    private lazy var tagCollectionPostAdd: UICollectionView = {
        let collection: UICollectionView
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        
        collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionLayout.minimumInteritemSpacing = 0
        collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 50), collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private lazy var chooseTagCollection: UICollectionView = {
        let collection: UICollectionView
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        
        collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionLayout.minimumInteritemSpacing = 0
        collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 50), collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .green
        return collection
    }()

    
    private lazy var tagsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    init(viewModel: PostAddViewModel = PostAddViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self

        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        subjectInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineOne)
        view.addSubview(lineTwo)
        view.addSubview(lineThree)
        view.addSubview(headerBar)
        view.addSubview(tagInputView)
        view.addSubview(chooseTagCollection)
        tagInputView.addSubview(tagLabel)
        tagInputView.addSubview(tagCollectionPostAdd)
        headerBar.addSubview(headerTitle)
        headerBar.addSubview(cancelButton)
        view.addSubview(subjectInput)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerBar.heightAnchor.constraint(equalToConstant: 77),
            headerBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            
            lineOne.heightAnchor.constraint(equalToConstant: 1),
            lineOne.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 0),
            lineOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            lineOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            headerTitle.centerXAnchor.constraint(equalTo: headerBar.centerXAnchor),
            headerTitle.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),
            
            cancelButton.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: headerBar.trailingAnchor, constant: -32),
            
            subjectInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            subjectInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            subjectInput.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 0),
            subjectInput.widthAnchor.constraint(equalTo: view.widthAnchor),
            subjectInput.heightAnchor.constraint(equalToConstant: 47),
            
            lineTwo.heightAnchor.constraint(equalToConstant: 1),
            lineTwo.topAnchor.constraint(equalTo: subjectInput.bottomAnchor, constant: 0),
            lineTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            lineTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            tagInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tagInputView.topAnchor.constraint(equalTo: lineTwo.bottomAnchor, constant: 0),
            tagInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tagInputView.heightAnchor.constraint(equalToConstant: 47),
            
            tagLabel.leadingAnchor.constraint(equalTo: tagInputView.leadingAnchor, constant: 8),
            tagLabel.centerYAnchor.constraint(equalTo: tagInputView.centerYAnchor),
            
            tagCollectionPostAdd.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 10),
            tagCollectionPostAdd.topAnchor.constraint(equalTo: tagInputView.topAnchor, constant: 0),
            tagCollectionPostAdd.trailingAnchor.constraint(equalTo: tagInputView.trailingAnchor, constant: 0),
            tagCollectionPostAdd.bottomAnchor.constraint(equalTo: tagInputView.bottomAnchor, constant: 0),
            
            lineThree.heightAnchor.constraint(equalToConstant: 1),
            lineThree.topAnchor.constraint(equalTo: tagCollectionPostAdd.bottomAnchor, constant: 0),
            lineThree.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            lineThree.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            chooseTagCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            chooseTagCollection.topAnchor.constraint(equalTo: lineThree.topAnchor, constant: 0),
            chooseTagCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            chooseTagCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
    private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func didTagsRefreshed() {
        tagCollectionPostAdd.reloadData()
    }
    
    func didTagsRefreshedInactives() {
        chooseTagCollection.reloadData()
    }
}


extension PostAdd: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == tagCollectionPostAdd ? viewModel.activeTags.count : viewModel.inactiveTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell
        let singleTag = collectionView == tagCollectionPostAdd ? viewModel.singleActiveTag(at: indexPath.row) : viewModel.singleInactiveTag(at: indexPath.row)
        
        cell?.configureWithName(with: singleTag)
        return cell ?? TagCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionPostAdd {
            viewModel.removeActiveTag(at: indexPath.row)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
            }) { _ in
                self.chooseTagCollection.reloadData()
            }
        } else {
            viewModel.removeInactiveTag(at: indexPath.row)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
            }) { _ in
                self.tagCollectionPostAdd.reloadData()
            }
        }
    }

}