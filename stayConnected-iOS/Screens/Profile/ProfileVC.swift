//
//  ProfileVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 01.12.24.
//

import UIKit
import Foundation

class ProfileVC: UIViewController, AvatarDelegate {
    private let viewModel: ProfileViewModel
    
    private lazy var spacerOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var spacerTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lineOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryGray
        return view
    }()
    
    private lazy var lineTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryGray
        return view
    }()
    
    private lazy var lineThree: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryGray
        return view
    }()
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Profile",
            color: .black,
            size: 20,
            weight: .bold
        )
        return label
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "shawn allan",
            color: .black,
            size: 17,
            weight: .bold
        )
        
        return label
    }()
    
    private lazy var mailLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "shawn@allan.com",
            color: .primaryGray,
            size: 15,
            weight: .regular
        )
        
        return label
    }()
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 60
        
        if let avatarName = UserDefaults.standard.string(forKey: "userAvatar") {
            image.image = UIImage(named: avatarName)
        }
        return image
    }()
    
    private lazy var cameraIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "camera")
        
        return image
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "INFORMATION",
            color: .primaryGray,
            size: 13,
            weight: .bold
        )
        
        return label
    }()
    
    private lazy var firstStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    private lazy var secondStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    private lazy var thirdStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Score",
            color: .primaryGray,
            size: 17,
            weight: .bold
        )
        
        return label
    }()
    
    private lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "234",
            color: .primaryGray,
            size: 17,
            weight: .bold
        )
        
        return label
    }()
    
    private lazy var answeredQLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Answered Questions",
            color: .primaryGray,
            size: 17,
            weight: .bold
        )
        
        return label
    }()
    
    private lazy var asnwersCountLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "15",
            color: .primaryGray,
            size: 17,
            weight: .bold
        )
        
        return label
    }()
    
    private lazy var logOutIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "logOutIcon")
        
        return image
    }()
    
    private lazy var logOutLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Log out",
            color: .primaryGray,
            size: 17,
            weight: .bold
        )
        
        return label
    }()
    
    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        viewModel.delegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(screenTitle)
        view.addSubview(avatarImage)
        view.addSubview(cameraIcon)
        view.addSubview(fullNameLabel)
        view.addSubview(mailLabel)
        view.addSubview(infoLabel)
        view.addSubview(firstStack)
        view.addSubview(secondStack)
        view.addSubview(thirdStack)
        view.addSubview(lineOne)
        view.addSubview(lineTwo)
        view.addSubview(lineThree)
        
        firstStack.addArrangedSubview(scoreLabel)
        firstStack.addArrangedSubview(spacerOne)
        firstStack.addArrangedSubview(pointsLabel)
        
        secondStack.addArrangedSubview(answeredQLabel)
        secondStack.addArrangedSubview(spacerTwo)
        secondStack.addArrangedSubview(asnwersCountLabel)
        
        thirdStack.addArrangedSubview(logOutIcon)
        thirdStack.addArrangedSubview(logOutLabel)
        
        let tapGestureAvatar = UITapGestureRecognizer(target: self, action: #selector(chooseAvatars))
        avatarImage.addGestureRecognizer(tapGestureAvatar)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMyanswers))
        secondStack.addGestureRecognizer(tapGesture)
        
        let tapGestureL = UITapGestureRecognizer(target: self, action: #selector(logOut))
        thirdStack.addGestureRecognizer(tapGestureL)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            screenTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            avatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImage.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 24),
            avatarImage.widthAnchor.constraint(equalToConstant: 120),
            avatarImage.heightAnchor.constraint(equalToConstant: 120),
            
            cameraIcon.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: -30),
            cameraIcon.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: -15),
            
            fullNameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
            fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mailLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 4),
            mailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: mailLabel.bottomAnchor, constant: 60),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            firstStack.heightAnchor.constraint(equalToConstant: 56),
            firstStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            firstStack.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12),
            firstStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            lineOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lineOne.topAnchor.constraint(equalTo: firstStack.bottomAnchor, constant: 0),
            lineOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lineOne.heightAnchor.constraint(equalToConstant: 1),
            
            secondStack.heightAnchor.constraint(equalToConstant: 56),
            secondStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            secondStack.topAnchor.constraint(equalTo: lineOne.bottomAnchor, constant: 18),
            secondStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            lineTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lineTwo.topAnchor.constraint(equalTo: secondStack.bottomAnchor, constant: 0),
            lineTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lineTwo.heightAnchor.constraint(equalToConstant: 1),
            
            thirdStack.heightAnchor.constraint(equalToConstant: 56),
            thirdStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            thirdStack.topAnchor.constraint(equalTo: lineTwo.bottomAnchor, constant: 18),
            thirdStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            lineThree.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lineThree.topAnchor.constraint(equalTo: thirdStack.bottomAnchor, constant: 0),
            lineThree.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lineThree.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    @objc func tapMyanswers() {
        print("my answers tapped")
    }
    
    @objc func logOut() {
        print("Log out initiated")
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = LoginVC ()
    }
    
    @objc func chooseAvatars() {
        let avatarVC = ChooseAvatarVC(viewModel: viewModel)
        avatarVC.modalPresentationStyle = .pageSheet
        
        if let sheet = avatarVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        present(avatarVC, animated: true)
    }
    
    func didAvatarChanged() {
        avatarImage.image = UIImage(named: viewModel.avatarName)
    }
}
