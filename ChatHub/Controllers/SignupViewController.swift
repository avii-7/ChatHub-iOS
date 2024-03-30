//
//  SignupViewController.swift
//  ChatHub
//
//  Created by Arun on 25/02/24.
//

import UIKit
import FirebaseAuth
import PhotosUI
import FirebaseStorage

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
    
    func didTapProfileImage() {
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let pickerViewController = PHPickerViewController(configuration: configuration)
            pickerViewController.delegate = self
            present(pickerViewController, animated: true)
            
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
        }
        
    }
    
    func didTapSignup(name: String?, email: String?, pass: String?, profileImage: UIImage?) async throws {
        
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
        
        let storageWrapper = FirebaseStorageWrapper(uid: user.uid)
        
        if
            let profileImage,
            let profileImageData = profileImage.pngData() {
            let url = try await storageWrapper.uploadProfileImage(uid: user.uid, profileImageData: profileImageData)
            profileChangeRequest.photoURL = url
        }
        
        try await profileChangeRequest.commitChanges()
        
        navigationController?.setViewControllers([ChatMessageViewController(user: user)], animated: true)
    }
    
    private func showAlert(msg: String) {
        let alertController = UIAlertController(title: "Alert !", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

extension SignupViewController: PHPickerViewControllerDelegate {
    
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemprovider = results.first?.itemProvider{
            
            if itemprovider.canLoadObject(ofClass: UIImage.self) {
                itemprovider.loadObject(ofClass: UIImage.self) { [weak self] image , error  in
                    if let error {
                        print(error)
                    }
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            //self.imageView.image = selectedImage
                            self?.signupView.setProfileImage(image: selectedImage)
                        }
                    }
                }
            }
        }
    }
}
