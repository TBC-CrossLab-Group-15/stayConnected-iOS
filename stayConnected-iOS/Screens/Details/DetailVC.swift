//
//  DetailVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 02.12.24.
//

import UIKit
import izziDateFormatter

class DetailVC: UIViewController {
    private let questionModel: QuestionModel
    private let izziDateFormatter: IzziDateFormatterProtocol
    
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
    
    init(questionModel: QuestionModel,
         izziDateFormatter: IzziDateFormatterProtocol = IzziDateFormatter()
    ) {
        self.questionModel = questionModel
        self.izziDateFormatter = izziDateFormatter
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
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(topicTitle)
        view.addSubview(postTitle)
        view.addSubview(askedDate)
        view.addSubview(commentsTable)

        configureView()
        setupConstraints()
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
            commentsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func configureView() {
        topicTitle.configureCustomText(
            text: questionModel.title,
            color: .primaryGray,
            fontName: "InterR",
            size: 13
        )
        
        postTitle.configureCustomText(
            text: questionModel.text,
            color: .black,
            fontName: "InterR",
            size: 16
        )
        let date = izziDateFormatter.formatDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", currentDate: questionModel.createDate, format: "dd/MM/yyyy")
        
        let time = izziDateFormatter.formatDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", currentDate: questionModel.createDate, format: "HH:mm")
        
        askedDate.configureCustomText(
            text: "\(date) at \(time)",
            color: .primaryGray,
            fontName: "InterR",
            size: 13
        )
    }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        questionModel.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell
        let currentAnswer = questionModel.answers[indexPath.row]
        cell?.configureCell(with: currentAnswer)
        cell?.selectionStyle = .none
        return cell ?? CommentCell()
    }
    
    
}
