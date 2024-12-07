//
//  AddFieldReusable.swift
//  stayConnected-iOS
//
//  Created by Despo on 03.12.24.
//

import UIKit
final class AddFieldReusable: UIView {
    private let placeHolder: String
    var onSendAction: (() -> Void)?
    
    private lazy var postInput: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = placeHolder
        field.clipsToBounds = true
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.primaryGray.cgColor
        field.layer.cornerRadius = 8
        field.keyboardType = .default
        
        let leftContainer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 47))
        field.leftView = leftContainer
        field.leftViewMode = .always
        
        let rightIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 47))
        let sendIcon = UIButton(type: .custom)
        sendIcon.setImage(UIImage(named: "sendQuestionIcon"), for: .normal)
        sendIcon.tintColor = .primaryGray
        sendIcon.frame = CGRect(x: 0, y: rightIconContainer.frame.height / 2 - 12, width: 24, height: 24)
        sendIcon.addTarget(self, action: #selector(sendIconTapped), for: .touchUpInside) // Add target
        
        rightIconContainer.addSubview(sendIcon)
        field.rightView = rightIconContainer
        field.rightViewMode = .always
        
        return field
    }()
    
    init(frame: CGRect = .zero, placeHolder: String) {
        self.placeHolder = placeHolder
        super.init(frame: .zero)
        
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(postInput)
        NSLayoutConstraint.activate([
            postInput.topAnchor.constraint(equalTo: topAnchor),
            postInput.leadingAnchor.constraint(equalTo: leadingAnchor),
            postInput.trailingAnchor.constraint(equalTo: trailingAnchor),
            postInput.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            postInput.heightAnchor.constraint(equalToConstant: 47)
        ])
    }
    
    func value() -> String {
        guard let valueString = postInput.text else { return "" }
        
        return valueString
    }
    
    func clearInput() {
        postInput.text = ""
    }
    
    @objc private func sendIconTapped() {
        onSendAction?()
    }
}
