//
//  DetailVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 02.12.24.
//

import UIKit
import izziDateFormatter

class DetailVC: UIViewController, ReloadAnswersDelegate {
    private var questionModel: QuestionModel
    private let izziDateFormatter: IzziDateFormatterProtocol
    private let viewModel: DetailViewModel
    private let keyService: KeychainService
    private let loadingIndicator: LoadingIndicator
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .backArrowCol
        button.addAction(UIAction(handler: {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var topicTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var postTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var showMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("show more", for: .normal)
        button.setTitleColor(.primaryViolet, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.isHidden = true
        return button
    }()
    
    private lazy var askedDate: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var noCommentLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "No Comments Yet",
            color: .primaryViolet,
            size: 22,
            weight: .heavy
        )
        label.isHidden = true
        view.addSubview(label)
        return label
    }()
    
    private lazy var noCommentsImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noQuestion")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        view.addSubview(image)
        return image
    }()
    
    private lazy var commentsTable: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        table.backgroundColor = .clear
        return table
    }()
    
    private let inputAnswer = AddFieldReusable(placeHolder: "Type your reply here")
    
    init(
        questionModel: QuestionModel,
        izziDateFormatter: IzziDateFormatterProtocol = IzziDateFormatter(),
        viewModel: DetailViewModel = DetailViewModel(),
        keyService: KeychainService = KeychainService(),
        loadingIndicator: LoadingIndicator = LoadingIndicator()
    ) {
        self.questionModel = questionModel
        self.izziDateFormatter = izziDateFormatter
        self.viewModel = viewModel
        self.keyService = keyService
        self.loadingIndicator = loadingIndicator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        viewModel.delegate = self
        viewModel.refetchCurrentPostAnswers(with: questionModel.id)
        view.backgroundColor = .primaryWhite
        inputAnswer.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topicTitle)
        contentView.addSubview(postTitle)
        contentView.addSubview(showMoreButton)
        contentView.addSubview(askedDate)
        contentView.addSubview(commentsTable)
        contentView.addSubview(inputAnswer)
        view.addSubview(loadingIndicator)
        view.bringSubviewToFront(loadingIndicator)
        
        setupConstraints()
        configureView()
        
        inputAnswer.onSendAction = {[weak self] in
            guard let self = self else { return }
            loadingIndicator.center = view.center
            loadingIndicator.startAnimating()
            
            let inputValue = inputAnswer.value()
            
            guard inputValue.count > 0 else {
                return showAlert(title: "Hold On a Sec…", message: "Enter your comment", buttonTitle: "Try Again")
            }
            
            let api = EndpointsEnum.answers.rawValue
            viewModel.collectAnswerInfo(api: api, answer: inputValue, postID: self.questionModel.id)
            viewModel.refetchCurrentPostAnswers(with: questionModel.id)
            inputAnswer.clearInput()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            topicTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topicTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            postTitle.topAnchor.constraint(equalTo: topicTitle.bottomAnchor, constant: 8),
            postTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            postTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            askedDate.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 8),
            askedDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            showMoreButton.topAnchor.constraint(equalTo: askedDate.bottomAnchor, constant: 8),
            showMoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            commentsTable.topAnchor.constraint(equalTo: showMoreButton.bottomAnchor, constant: 0),
            commentsTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            commentsTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            commentsTable.heightAnchor.constraint(equalToConstant: 500),
            
            inputAnswer.topAnchor.constraint(equalTo: commentsTable.bottomAnchor, constant: 16),
            inputAnswer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            inputAnswer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            inputAnswer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            noCommentLabel.topAnchor.constraint(equalTo: askedDate.bottomAnchor, constant: 100),
            noCommentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            noCommentsImage.topAnchor.constraint(equalTo: noCommentLabel.bottomAnchor, constant: 10),
            noCommentsImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureView() {
        var isFullyVisible = false
        
        topicTitle.configureCustomText(
            text: questionModel.title,
            color: .primaryGray,
            size: 13,
            weight: .regular
        )
        
        postTitle.configureCustomText(
            text: questionModel.text,
            color: .primaryBack,
            size: 20,
            weight: .regular,
            lineNumber: 10
        )
        
        let date = izziDateFormatter.isoTimeFormatter(
            currentDate: questionModel.createDate,
            finalFormat: "dd/MM/yyyy",
            timeZoneOffset: 4
        )
        
        let time = izziDateFormatter.isoTimeFormatter(
            currentDate: questionModel.createDate,
            finalFormat: "HH:mm",
            timeZoneOffset: 4
        )
        
        askedDate.configureCustomText(
            text: "\(questionModel.user.firstName) asked \(date) at \(time)",
            color: .primaryGray,
            size: 13,
            weight: .regular
        )
        
        if postTitle.text?.count ?? 0 > 550 {
            showMoreButton.isHidden = false
        }
        
        showMoreButton.addAction(UIAction(handler: {[weak self] _ in
            isFullyVisible.toggle()
            
            self?.postTitle.numberOfLines = isFullyVisible ? 0 : 10
            self?.showMoreButton.setTitle(isFullyVisible ? "show less" : "show more", for: .normal)
        }), for: .touchUpInside)
    }
    
    func didAnswersFetched() {
        commentsTable.reloadData()
        loadingIndicator.stopAnimating()
        
        if viewModel.answersArray.count == 0 {
            commentsTable.isHidden = true
            noCommentsImage.isHidden = false
            noCommentLabel.isHidden = false
        } else {
            commentsTable.isHidden = false
            noCommentsImage.isHidden = true
            noCommentLabel.isHidden = true
        }
    }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.answersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell
        let currentAnswer = viewModel.singleAnswer(at: indexPath.row)
        cell?.configureCell(with: currentAnswer)
        cell?.selectionStyle = .none
        return cell ?? CommentCell()
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let myID = try? keyService.retrieveUserID() else {
            return UISwipeActionsConfiguration()
        }
        
        let currentAnswer = viewModel.singleAnswer(at: indexPath.row)
        let currentQuestionID = questionModel.id
        
        if currentAnswer.user.id == Int(myID) {
            let deleteAnswer = UIContextualAction(style: .normal, title: "Delete") {[weak self] action, view, completionHandler in
                
                self?.deletionHandler(with: currentAnswer.id, and: currentQuestionID)
                completionHandler(true)
            }
            deleteAnswer.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAnswer])
        }
        
        guard questionModel.user.id == Int(myID) else {
            return UISwipeActionsConfiguration()
        }
        
        guard currentAnswer.user.id != Int(myID) else {
            return UISwipeActionsConfiguration()
        }
        
        
        if currentAnswer.isCorrect {
            let rejectedAnswer = UIContextualAction(style: .destructive, title: "Reject") {[weak self] action, view, completionHandler in
                self?.actionHandler(at: indexPath.row)
                completionHandler(true)
            }
            rejectedAnswer.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [rejectedAnswer])
        } else {
            let acceptedAnswer = UIContextualAction(style: .normal, title: "Accept") {[weak self] action, view, completionHandler in
                
                self?.actionHandler(at: indexPath.row)
                completionHandler(true)
            }
            acceptedAnswer.backgroundColor = .primaryViolet
            return UISwipeActionsConfiguration(actions: [acceptedAnswer])
        }
    }
    
    private func actionHandler(at index: Int) {
        loadingIndicator.startAnimating()
        viewModel.checkAnswer(at: index, postID: questionModel.id)
    }
    
    private func deletionHandler(with index: Int, and postID: Int) {
        loadingIndicator.startAnimating()
        viewModel.deleteComment(with: index, and: postID)
    }
}
