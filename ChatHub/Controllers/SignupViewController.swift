//
//  SignupViewController.swift
//  ChatHub
//
//  Created by Arun on 25/02/24.
//

import UIKit
import FirebaseAuth

final class SignupViewController: UIViewController {
    
    private let signupView = SignupView()
    
    private var credentialValidator = CredentialValidatorHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews() {
        view.addSubview(signupView)
        view.backgroundColor = .systemBackground
        signupView.translatesAutoresizingMaskIntoConstraints = false
        signupView.delegate = self
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            signupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signupView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            signupView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            signupView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension SignupViewController: SignupViewDelegate {
    
    func didTapSignup(name: String?, email: String?, pass: String?) async throws {
        let validationResult = credentialValidator.validate(name: name, email: email, pass: pass)
        
        if validationResult.success == false {
            if let error = validationResult.error {
                showAlert(msg: error)
            }
            return
        }
        
        guard let name, let email, let pass else {
            showAlert(msg: "Something went wrong !")
            return
        }
        
        let result = try await Auth.auth().createUser(withEmail: email, password: pass)
        let user = result.user
        let profileChangeRequest = user.createProfileChangeRequest()
        profileChangeRequest.displayName = name
        try await profileChangeRequest.commitChanges()
        
        navigationController?.setViewControllers([ChatViewController(user: user)], animated: true)
    }
    
    private func showAlert(msg: String) {
        let alertController = UIAlertController(title: "Alert !", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
