//
//  SignupVC.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

class SignUpVC: UIViewController {
    private var viewModel: SignUpViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        button.addAction(UIAction(handler: {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.configureCustomText(
            text: "Sign Up",
            color: .black,
            size: 30,
            weight: .bold
        )
        
        return label
    }()
    
    private let name = InputFieldReusable(
        isLabelHidden: false,
        labelName: "Name",
        placeholder: "Name",
        isPassword: false
    )
    
    private let surnName = InputFieldReusable(
        isLabelHidden: false,
        labelName: "Last Name",
        placeholder: "Last Name",
        isPassword: false
    )
    
    private let email = InputFieldReusable(
        isLabelHidden: false,
        labelName: "Email",
        placeholder: "Email",
        isPassword: false
    )
    
    private let newPassword = InputFieldReusable(
        isLabelHidden: false,
        labelName: "Enter Password",
        placeholder: "Enter Password",
        isPassword: true
    )
    
    private let confirmPassword = InputFieldReusable(
        isLabelHidden: false,
        labelName: "Confirm Password",
        placeholder: "Confirm Password",
        isPassword: true
    )
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.configureCustomButton(
            title: "Sign Up",
            color: .white,
            fontName: "InterS",
            fontSize: 16,
            cornerR: 12,
            bgColor: .primaryViolet
        )
        
        return button
    }()
    
    init(viewModel: SignUpViewModel = SignUpViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        
        name.translatesAutoresizingMaskIntoConstraints = false
        surnName.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        newPassword.translatesAutoresizingMaskIntoConstraints = false
        confirmPassword.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(screenTitle)
        contentView.addSubview(name)
        contentView.addSubview(surnName)
        contentView.addSubview(email)
        contentView.addSubview(newPassword)
        contentView.addSubview(confirmPassword)
        contentView.addSubview(signUpButton)
        
        setupConstraints()
        
        signUpButton.addAction(UIAction(handler: {[weak self] _ in
            self?.signupAction()
        }), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            screenTitle.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12),
            screenTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            
            name.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 33),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            
            surnName.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 33),
            surnName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            surnName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            
            email.topAnchor.constraint(equalTo: surnName.bottomAnchor, constant: 33),
            email.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            email.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            
            newPassword.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 33),
            newPassword.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            newPassword.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            
            confirmPassword.topAnchor.constraint(equalTo: newPassword.bottomAnchor, constant: 33),
            confirmPassword.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            confirmPassword.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            
            signUpButton.topAnchor.constraint(greaterThanOrEqualTo: confirmPassword.bottomAnchor, constant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 33),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -33),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -109),
            signUpButton.heightAnchor.constraint(equalToConstant: 59)
        ])
    }

    private func errorModal(text: String) {
            let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    private func signupAction() {
        let nameValue = name.value()
        let surnameValue = surnName.value()
        let isCorrectEmail = viewModel.isValidEmail(email.value())
        let emailValue = email.value()
        let pwdValue = newPassword.value()
        let confirmPwdValue = confirmPassword.value()
        let isEnglishChars = viewModel.stringCheck(nameValue)
        let isEnglishCharsSurname = viewModel.stringCheck(surnameValue)
        let isStrongPassword = viewModel.strongPasswordCheck(pwdValue)
        let isPasswordsEqual = viewModel.checkPasswords(
            pwdOne: newPassword.value(),
            pwdTwo: confirmPassword.value()
        )
        
        guard nameValue.count >= 3 else {
            return errorModal(text: "name must be more than 3")
        }
        
        guard isEnglishChars else {
            return errorModal(text: "Enter name with english")
        }
        
        guard surnameValue.count >= 3 else {
            return errorModal(text: "surname must be more than 3")
        }
        
        guard isEnglishCharsSurname else {
            return errorModal(text: "Enter surname with english")
        }

        guard isCorrectEmail else {
            return errorModal(text: "not email")
        }
        
        guard pwdValue.count >= 8 else {
            return errorModal(text: "password must be at last 8")
        }
        
        guard isStrongPassword else {
            return errorModal(text: "password is weak")
        }
        
        guard isPasswordsEqual else {
            return errorModal(text: "Passwords not equal")
        }
    
        viewModel.signUpAction(
            firstName: nameValue,
            lastName: surnameValue,
            email: emailValue,
            password: pwdValue,
            confirmPassword: confirmPwdValue
        )
    }
}
