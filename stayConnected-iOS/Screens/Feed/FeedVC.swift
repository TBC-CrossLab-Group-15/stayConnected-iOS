//
//  Feed.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class FeedVC: UIViewController, FeedModelDelegate {
    private let viewModel: FeedViewModel
    
    private let spacerOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var toggler = true
    
    private lazy var topStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 0
        
        return stack
    }()
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Questions",
            color: .black,
            fontName: "InterB",
            size: 20
        )
        
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addIcon"), for: .normal)
        button.addAction(UIAction(handler: {[weak self] _ in
            self?.addPost()
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var topButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 10
        
        return stack
    }()
    
    private lazy var buttonGeneral: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("General", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.addAction(UIAction(handler: {[weak self] _ in
            self?.toggler = true
            self?.updateButtonColors()
        }), for: .touchUpInside)
        button.backgroundColor = toggler ? .primaryViolet : .primaryGray
        return button
    }()
    
    private lazy var buttonPersonal: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Personal", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.addAction(UIAction(handler: {[weak self] _ in
            self?.toggler = false
            self?.updateButtonColors()
        }), for: .touchUpInside)
        button.backgroundColor = toggler ? .primaryGray : .primaryViolet
        return button
    }()
    
    private lazy var searchBar: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Search"
        field.clipsToBounds = true
        field.layer.cornerRadius = 8
        field.backgroundColor = .bgWhite
        field.keyboardType = .default
        
        let leftIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 28))
        let lockIcon = UIImageView(image: UIImage(named: "search"))
        lockIcon.tintColor = .primaryGray
        lockIcon.frame = CGRect(x: 8, y: leftIconContainer.frame.height / 2 - 14, width: 28, height: 28)
        leftIconContainer.addSubview(lockIcon)
        
        field.leftView = leftIconContainer
        field.leftViewMode = .always
        
        return field
    }()
    
    private lazy var tagCollection: UICollectionView = {
        let collection: UICollectionView
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        
        collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionLayout.minimumInteritemSpacing = 10
        collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    private lazy var noQstack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 15
        
        return stack
    }()
    
    private lazy var noQuestionLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "No questions yet",
            color: .primaryGray,
            fontName: "InterR",
            size: 15,
            alignment: .center
        )
        
        return label
    }()
    
    private lazy var beFirstLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Be the first to ask one",
            color: .black,
            fontName: "InterR",
            size: 15
        )
        return label
    }()
    
    private lazy var noQuestionImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "noQuestion")
        
        return image
    }()
    
    private lazy var questionsTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(QuestionCell.self, forCellReuseIdentifier: "QuestionCell")
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgWhite
        return tableView
    }()
    
    init(viewModel: FeedViewModel = FeedViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noQstack.isHidden = viewModel.questionsCount > 0 ? true : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(topStack)
        topStack.addArrangedSubview(screenTitle)
        topStack.addArrangedSubview(spacerOne)
        topStack.addArrangedSubview(addButton)
        view.addSubview(topButtonsStack)
        topButtonsStack.addArrangedSubview(buttonGeneral)
        topButtonsStack.addArrangedSubview(buttonPersonal)
        view.addSubview(searchBar)
        view.addSubview(tagCollection)
        view.addSubview(noQstack)
        noQstack.addArrangedSubview(noQuestionLabel)
        noQstack.addArrangedSubview(beFirstLabel)
        noQstack.addArrangedSubview(noQuestionImage)
        view.addSubview(questionsTable)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            topButtonsStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 20),
            topButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            buttonGeneral.heightAnchor.constraint(equalToConstant: 39),
            buttonGeneral.widthAnchor.constraint(equalTo: topButtonsStack.widthAnchor, multiplier: 0.5, constant: -10),
            buttonPersonal.heightAnchor.constraint(equalToConstant: 39),
            buttonPersonal.widthAnchor.constraint(equalTo: topButtonsStack.widthAnchor, multiplier: 0.5, constant: -10),
            
            searchBar.topAnchor.constraint(equalTo: topButtonsStack.bottomAnchor, constant: 19),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 38),
            
            tagCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            tagCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tagCollection.heightAnchor.constraint(equalToConstant: 54),
            
            noQstack.topAnchor.constraint(equalTo: tagCollection.bottomAnchor, constant: 90),
            noQstack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noQstack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            questionsTable.topAnchor.constraint(equalTo: tagCollection.bottomAnchor, constant: 0),
            questionsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            questionsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            questionsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])
    }
    
    private func updateButtonColors() {
        buttonGeneral.backgroundColor = toggler ? .primaryViolet : .primaryGray
        buttonPersonal.backgroundColor = toggler ? .primaryGray : .primaryViolet
    }
    
    func didDataFetched() {
        noQstack.isHidden = viewModel.questionsCount > 0 ? true : false
        questionsTable.isHidden = viewModel.questionsCount > 0 ? false : true
        questionsTable.reloadData()
    }
    
    private func addPost() {
        present(PostAdd(), animated: true, completion: nil)
    }
}


extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tagsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell
        
        let currentTag = viewModel.singleTag(whit: indexPath.row)
        cell?.configureCell(with: currentTag)
        
        return cell ?? TagCell()
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.questionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as? QuestionCell
        cell?.selectionStyle = .none
        let currentQuestion = viewModel.singleQuestion(with: indexPath.row)
        cell?.configureCell(with: currentQuestion)
        
        return cell ?? QuestionCell()
    }
    
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let selectedQuestion = viewModel.singleQuestion(with: indexPath.row)
    //
    //    }
}


