//
//  SignupView.swift
//  ChatHub
//
//  Created by Arun on 25/02/24.
//

import UIKit

protocol SignupViewDelegate: AnyObject {
    func didTapSignup(name: String?, email: String?, pass: String?) async throws
}

final class SignupView: UIView {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ChatHub"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .roundedRect
        textField.placeholder = "Name"
        textField.minimumFontSize = 18
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .namePhonePad
        textField.autocapitalizationType = .sentences
        return textField
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        textField.minimumFontSize = 18
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.contentMode = .scaleToFill
        textField.contentHorizontalAlignment = .left
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.minimumFontSize = 17
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()

    private let signupButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        if #available(iOS 15.0, *) {
            button.configuration = .filled()
        } else {
            button.contentEdgeInsets = .init(top: 10, left: 15, bottom: 10, right: 15)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 10
        }
        button.setTitle("SIGNUP", for: .normal)
        return button
    }()
    
    weak var delegate: SignupViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signupButton)
        signupButton.addTarget(self, action: #selector(didTapSignupButton), for: .touchUpInside)
        addConstraints()
    }
    
    @objc
    private func didTapSignupButton() {
        
        Task {
            do {
                try await delegate?.didTapSignup(name: nameTextField.text, email: emailTextField.text, pass: passwordTextField.text)
            }
            catch {
                debugPrint("Error \(error)")
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 45),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),

            signupButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            signupButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

