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
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backIcon"), for: .normal)
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
        return table
    }()
    
    private let inputAnswer = AddFieldReusable(placeHolder: "Type your reply here")
    
    init(
        questionModel: QuestionModel,
        izziDateFormatter: IzziDateFormatterProtocol = IzziDateFormatter(),
        viewModel: DetailViewModel = DetailViewModel(),
        keyService: KeychainService = KeychainService()
    ) {
        self.questionModel = questionModel
        self.izziDateFormatter = izziDateFormatter
        self.viewModel = viewModel
        self.keyService = keyService
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
        viewModel.getSinglePost(with: questionModel.id)
        view.backgroundColor = .white
        inputAnswer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        view.addSubview(topicTitle)
        view.addSubview(postTitle)
        view.addSubview(askedDate)
        view.addSubview(commentsTable)
        view.addSubview(inputAnswer)
        
        setupConstraints()
        configureView()
        
        inputAnswer.onSendAction = {[weak self] in
            guard let self = self else { return }
            let inputValue = inputAnswer.value()
            
            let api = "https://stayconnected.lol/api/posts/answers/"
            viewModel.collectAnswerInfo(api: api, answer: inputValue, postID: self.questionModel.id)
            viewModel.getSinglePost(with: questionModel.id)
            inputAnswer.clearInput()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            topicTitle.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12),
            topicTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            postTitle.topAnchor.constraint(equalTo: topicTitle.bottomAnchor, constant: 4),
            postTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            postTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            askedDate.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 4),
            askedDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            commentsTable.topAnchor.constraint(equalTo: askedDate.bottomAnchor, constant: 20),
            commentsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            commentsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            commentsTable.bottomAnchor.constraint(equalTo: inputAnswer.topAnchor, constant: -12),
            
            inputAnswer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            inputAnswer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            inputAnswer.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            noCommentLabel.topAnchor.constraint(equalTo: askedDate.bottomAnchor, constant: 100),
            noCommentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            noCommentsImage.topAnchor.constraint(equalTo: noCommentLabel.bottomAnchor, constant: 10),
            noCommentsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func configureView() {
        topicTitle.configureCustomText(
            text: questionModel.title,
            color: .primaryGray,
            size: 13,
            weight: .regular
        )
        
        postTitle.configureCustomText(
            text: questionModel.text,
            color: .black,
            size: 20,
            weight: .regular
        )
        let date = izziDateFormatter.formatDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", currentDate: questionModel.createDate, format: "dd/MM/yyyy")
        
        let time = izziDateFormatter.formatDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", currentDate: questionModel.createDate, format: "HH:mm")
        
        askedDate.configureCustomText(
            text: "\(questionModel.user.firstName) asked \(date) at \(time)",
            color: .primaryGray,
            size: 13,
            weight: .regular
        )
    }
    
    func didAnswersFetched() {
        commentsTable.reloadData()
        
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
                print(currentAnswer)
                self?.actionHandler(at: indexPath.row)
                completionHandler(true)
            }
            acceptedAnswer.backgroundColor = .primaryViolet
            return UISwipeActionsConfiguration(actions: [acceptedAnswer])
        }
    }
    
    
    private func actionHandler(at index: Int) {
        print("Accepted user: \(index)")
        viewModel.checkAnswer(at: index, postID: questionModel.id)
    }
}
