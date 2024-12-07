//
//  InputFieldReusable.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

final class InputFieldReusable: UIView {
    private let labelName: String
    private let isLabelHidden: Bool
    private let placeholder: String
    private let isPassword: Bool
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    private lazy var inputLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelName
        label.textColor = .primaryGray
        
        return label
    }()
    
    private lazy var inputField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = placeholder
        field.isSecureTextEntry = isPassword
        field.clipsToBounds = true
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.primaryGray.cgColor
        field.layer.cornerRadius = 8
        field.keyboardType = .default
        field.autocapitalizationType = .none
        
        if isPassword {
            let leftIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 51))
            let lockIcon = UIImageView(image: UIImage(named: "lock"))
            lockIcon.tintColor = .primaryGray
            lockIcon.frame = CGRect(x: 8, y: leftIconContainer.frame.height / 2 - 12, width: 24, height: 24)
            leftIconContainer.addSubview(lockIcon)
            
            field.leftView = leftIconContainer
            field.leftViewMode = .always
            
            let rightIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 51))
            let eyeIcon = UIButton(type: .custom)
            eyeIcon.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            eyeIcon.tintColor = .primaryGray
            eyeIcon.frame = CGRect(x: 0, y: rightIconContainer.frame.height / 2 - 12, width: 24, height: 24)
            
            eyeIcon.addAction(UIAction(handler: { [weak self] action in
                guard let button = action.sender as? UIButton else { return }
                self?.toggleVisibility(button)
            }), for: .touchUpInside)
            
            rightIconContainer.addSubview(eyeIcon)
            field.rightView = rightIconContainer
            field.rightViewMode = .always
        } else {
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
            field.leftView = leftPaddingView
            field.leftViewMode = .always
        }
        
        return field
    }()
    
    init(isLabelHidden: Bool ,labelName: String, placeholder: String, isPassword: Bool) {
        self.isLabelHidden = isLabelHidden
        self.labelName = labelName
        self.placeholder = placeholder
        self.isPassword = isPassword
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stack)
        
        if !isLabelHidden {
            stack.addArrangedSubview(inputLabel)
        }
        
        stack.addArrangedSubview(inputField)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            inputField.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func toggleVisibility(_ sender: UIButton) {
        inputField.isSecureTextEntry.toggle()
        let eyeIcon = inputField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: eyeIcon), for: .normal)
    }
    
    func value() -> String {
        guard let valueString = inputField.text else { return "" }
        return valueString
    }
}
