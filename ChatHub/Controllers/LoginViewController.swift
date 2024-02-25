//
//  ViewController.swift
//  ChatHub
//
//  Created by Arun on 19/02/24.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    private var credentialValidator = CredentialValidatorHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews() {
        view.addSubview(loginView)
        view.backgroundColor = .systemBackground
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.delegate = self
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            loginView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension LoginViewController: LoginViewDelegate {

    @MainActor
    func didTapLogin(email: String?, pass: String?) async throws {
        
        let validationResult = credentialValidator.validate(email: email, pass: pass)
        
        if validationResult.success == false {
            if let error = validationResult.error {
                showAlert(msg: error)
            }
            return
        }
        
        guard let email, let pass else {
            showAlert(msg: "Something went wrong !")
            return
        }
        
        let authResult = try await Auth.auth().signIn(withEmail: email, password: pass)
        let user = authResult.user
        
        navigationController?.setViewControllers([ChatViewController(user: user)], animated: true)
    }
    
    func didTapSignup() {
        navigationController?.pushViewController(SignupViewController(), animated: true)
    }
    
    private func showAlert(msg: String) {
        let alertController = UIAlertController(title: "Alert !", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
