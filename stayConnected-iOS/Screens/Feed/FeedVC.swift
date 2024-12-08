//
//  Feed.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class FeedVC: UIViewController, FeedModelDelegate, TagsModelDelegate, SearchedInfoDelegate, PresentedVCDelegate {
    
    private let viewModel: FeedViewModel
    private let keyService: KeychainService
    private let postAddVC: PostAdd
    private let loadingIndicator: LoadingIndicator
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
            color: .primaryBack,
            size: 20,
            weight: .bold
        )
        
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .primaryViolet
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
        button.setTitleColor(.primaryWhite, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.addAction(UIAction(handler: {[weak self] _ in
            self?.toggler = true
            self?.updateButtonColors()
            self?.loadingIndicator.startAnimating()
            self?.viewModel.updatePages()
        }), for: .touchUpInside)
        button.backgroundColor = toggler ? .primaryViolet : .primaryGray
        return button
    }()
    
    private lazy var buttonPersonal: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Personal", for: .normal)
        button.setTitleColor(.primaryWhite, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.addAction(UIAction(handler: {[weak self] _ in
            self?.toggler = false
            self?.updateButtonColors()
            self?.loadingIndicator.startAnimating()
            self?.viewModel.currentUserQuestions()
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
        let searchIcon = UIImageView(image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate))
        searchIcon.tintColor = .primaryGray
        searchIcon.frame = CGRect(x: 8, y: leftIconContainer.frame.height / 2 - 14, width: 28, height: 28)
        leftIconContainer.addSubview(searchIcon)
        
        field.leftView = leftIconContainer
        field.leftViewMode = .always
        
        field.addAction(UIAction(handler: {[weak self] _ in
            self?.viewModel.searchByTitle(with: field.text ?? "")
        }), for: .editingChanged)
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
            size: 15,
            weight: .bold,
            alignment: .center
        )
        
        return label
    }()
    
    private lazy var beFirstLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Be the first to ask one",
            color: .primaryBack,
            size: 15,
            weight: .bold
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgWhite
        return tableView
    }()
    
    init(
        viewModel: FeedViewModel = FeedViewModel(),
        keyService: KeychainService = KeychainService(),
        postAddVC: PostAdd = PostAdd(),
        loadingIndicator: LoadingIndicator = LoadingIndicator()
    ) {
        self.viewModel = viewModel
        self.keyService = keyService
        self.postAddVC = postAddVC
        self.loadingIndicator = loadingIndicator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noQstack.isHidden = viewModel.questionsCount > 0 ? true : false
        loadingIndicator.startAnimating()
        if viewModel.isPersonalData {
            viewModel.currentUserQuestions()
        } else {
            viewModel.updatePages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        viewModel.delegate = self
        viewModel.tagsDelegate = self
        viewModel.searchedInfoDelegate = self
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .primaryWhite
        
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
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        view.bringSubviewToFront(loadingIndicator)
        loadingIndicator.center = view.center
        
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
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
        loadingIndicator.stopAnimating()
    }
    
    func didTagsFetched() {
        tagCollection.reloadData()
    }
    
    func didSearchedInfoFetched() {
        noQstack.isHidden = viewModel.questionsCount > 0 ? true : false
        questionsTable.isHidden = viewModel.questionsCount > 0 ? false : true
        questionsTable.reloadData()
        loadingIndicator.stopAnimating()
        
        if !viewModel.isPersonalData {
            buttonGeneral.backgroundColor = .primaryViolet
            buttonPersonal.backgroundColor = .primaryGray
        }
    }
    
    private func addPost() {
        postAddVC.delegate = self
        self.present(postAddVC, animated: true, completion: nil)
    }
    
    func didDismissPresentedVC() {
        if viewModel.isPersonalData {
            viewModel.currentUserQuestions()
        } else {
            viewModel.updatePages()
        }
    }
}


extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell
        
        let currentTag = viewModel.singleTag(whit: indexPath.row)
        cell?.configureCell(with: currentTag)
        return cell ?? TagCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentTagName = viewModel.singleTag(whit: indexPath.row).name
        viewModel.searchByTag(with: currentTagName)
        loadingIndicator.startAnimating()
        if currentTagName == "All" {
            searchBar.text = ""
        }
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
        
        if indexPath.row == viewModel.questionsCount - 1 && viewModel.questionsCount >= 10 {
            viewModel.updatePages()
        }
        
        return cell ?? QuestionCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentQuestion = viewModel.singleQuestion(with: indexPath.row)
        let vc  = DetailVC(questionModel: currentQuestion)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentQuestion = viewModel.singleQuestion(with: indexPath.row)
        
        guard let myID = try? keyService.retrieveUserID() else {
            return UISwipeActionsConfiguration()
        }
        guard currentQuestion.user.id == Int(myID) else {
            return UISwipeActionsConfiguration()
        }
        
        let rejectedAnswer = UIContextualAction(style: .destructive, title: "Delete") {[weak self] action, view, completionHandler in
            self?.actionHandler(at: currentQuestion.id)
            completionHandler(true)
        }
        rejectedAnswer.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [rejectedAnswer])
        
    }
    
    private func actionHandler(at postID: Int) {
        viewModel.deletePost(with: postID)
        loadingIndicator.startAnimating()
    }
}


