//
//  LoginVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

class LoginVC: UIViewController, LoginNavigationDelegate, LoginErrorDelegate {
    private let viewModel: LoginViewModel
    private let isSmallScreen = UIScreen.main.bounds.height < 800 ? true : false
    private lazy var spacerOne: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var spacerTwo: UIView = {
        let view = UIView()
        return view
    }()
    
    private let loadingIndicator: LoadingIndicator
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Log in",
            color: .primaryBack,
            size: 30,
            weight: .bold
        )
        
        return label
    }()
    
    private lazy var pwdStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 0
        
        return stack
    }()
    
    private lazy var pwdLabel: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Password",
            color: .primaryGray,
            size: 12,
            weight: .regular
        )
        
        return label
    }()
    
    private lazy var forgetPwdButton: UIButton = {
        let button = UIButton()
        button.configureCustomButton(
            title: "Forgot Password?",
            color: .primaryGray,
            fontName: "InterR",
            fontSize: 12
        )
        
        return button
    }()
    
    private lazy var signUpStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 0
        
        return stack
    }()
    
    private lazy var signupTitle: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "New To StayConnected?",
            color: .primaryGray,
            size: 12,
            weight: .regular
        )
        
        return label
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.configureCustomButton(
            title: "Sign Up",
            color: .primaryGray,
            fontName: "InterR",
            fontSize: 18
        )
        
        return button
    }()
    
    let userNameInput = InputFieldReusable(
        isLabelHidden: false,
        labelName: "Email",
        placeholder: "Email",
        isPassword: false
    )
    
    let passwordField = InputFieldReusable(
        isLabelHidden: true,
        labelName: "Password",
        placeholder: "Enter Your Password",
        isPassword: true
    )
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.configureCustomButton(
            title: "Log In",
            color: .primaryWhite,
            fontName: "InterS",
            fontSize: 16,
            cornerR: 12,
            bgColor: .primaryViolet
        )
        
        return button
    }()
    
    init(
        viewModel: LoginViewModel = LoginViewModel(),
        loadingIndicator: LoadingIndicator = LoadingIndicator()
    ) {
        self.viewModel = viewModel
        self.loadingIndicator = loadingIndicator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .primaryWhite
        viewModel.delegate = self
        viewModel.errorDelebate = self

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        userNameInput.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(loadingIndicator)
        view.addSubview(screenTitle)
        view.addSubview(userNameInput)
        view.addSubview(pwdStack)
        pwdStack.addArrangedSubview(pwdLabel)
        pwdStack.addArrangedSubview(spacerOne)
        pwdStack.addArrangedSubview(forgetPwdButton)
        view.addSubview(passwordField)
        view.addSubview(signUpStack)
        signUpStack.addArrangedSubview(signupTitle)
        signUpStack.addArrangedSubview(spacerTwo)
        signUpStack.addArrangedSubview(signupButton)
        view.addSubview(loginButton)
    
        setupConstraints()
        
        loginButton.addAction(UIAction(handler: { [weak self] _ in
            self?.login()
        }), for: .touchUpInside)
      
        signupButton.addAction(UIAction(handler: {[weak self] _ in
            self?.signUP()
        }), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: isSmallScreen ? 50 : 123),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userNameInput.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: isSmallScreen ? 33 : 76),
            userNameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            userNameInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
            
            pwdStack.topAnchor.constraint(equalTo: userNameInput.bottomAnchor, constant: 39),
            pwdStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            pwdStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
            
            passwordField.topAnchor.constraint(equalTo: pwdStack.bottomAnchor, constant: 8),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
            
            signUpStack.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            signUpStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            signUpStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -109),
            loginButton.heightAnchor.constraint(equalToConstant: 59)
        ])
    }
    
    private func login() {
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        
        let userNameValue = userNameInput.value()
        let passwordValue = passwordField.value()
        
        guard !userNameValue.isEmpty else {
            return showAlert(title: "Let’s Fix This", message: "Enter username", buttonTitle: "Try Again")
        }
        
        guard !passwordValue.isEmpty else {
            return showAlert(title: "Let’s Fix This", message: "Enter password", buttonTitle: "Try Again")
        }
        
        viewModel.loginAction(email: userNameValue, password: passwordValue)
    }
    
    private func resetPassword() {
        
    }
    
    private func signUP() {
        navigationController?.pushViewController(SignUpVC(), animated: true)
    }
    
    func navigateToFeed() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = TabBarController()
    }
    
    func didLoginFailed() {
        showAlert(title: "Let’s Fix This", message: "Invalid username or password", buttonTitle: "Try Again")
    }
}

