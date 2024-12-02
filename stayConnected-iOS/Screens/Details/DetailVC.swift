//
//  DetailVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 02.12.24.
//

import UIKit

class DetailVC: UIViewController {
    private let questionModel: QuestionModel
    
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
    
    init(questionModel: QuestionModel) {
        self.questionModel = questionModel
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
        view.backgroundColor = .red
        print(questionModel)
        
        view.addSubview(backButton)
        view.addSubview(topicTitle)
        view.addSubview(postTitle)
        
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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
