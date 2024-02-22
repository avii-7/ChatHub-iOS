//
//  ViewController.swift
//  ChatHub
//
//  Created by Arun on 19/02/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

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
        return textField
    }()

    private let logInButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Button", for: .normal)
        if #available(iOS 15.0, *) {
            button.configuration = .filled()
        } else {
            // Fallback on earlier versions
        }
        button.setTitle("LOGIN", for: .normal)
        return button
    }()
    
     @objc func didTapLoginButton() {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        let validationResult = ValidationHelper.validate(email: email, pass: password)
        
        if(validationResult.success) {
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] result, error in
                guard let self else { return }
                
                if error == nil {
                    let alertController = UIAlertController(title: "Success", message: result?.user.displayName, preferredStyle: .alert)
                    alertController.addAction(.init(title: "OK", style: .default, handler: { action in
                        self.navigationController?.pushViewController(ChatViewController(), animated: true)
                    }))
                    self.present(alertController, animated: true)
                }
            }
        }
        else {
            // show error
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        
        addConstraints()
        
        logInButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            view.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),

            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            logInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

