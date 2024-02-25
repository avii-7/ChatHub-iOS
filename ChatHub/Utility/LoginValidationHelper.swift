//
//  ValidationHelper.swift
//  ChatHub
//
//  Created by Arun on 20/02/24.
//

import Foundation

struct ValidationResult {
    var success: Bool
    var error: String?
}

protocol CredentialValidator {
    func validate(userName: String?, email: String?, pass: String?) -> ValidationResult
    func validate(email: String?, pass: String?) -> ValidationResult
}

struct CredentialValidatorHelper : CredentialValidator{
    
    func validate(userName: String?, email: String?, pass: String?) -> ValidationResult {
        .init(success: false)
    }
    
    
    func validate(email: String?, pass: String?) -> ValidationResult {
        
        let success: Bool
        let error: String?
        
        if email == nil || email!.isEmpty {
            success = false
            error = "Email address can't be empty."
        }
        else if pass == nil || pass!.isEmpty {
            success = false
            error = "Password can't be empty."
        }
        else{
            success = true
            error = nil
        }
        
        return ValidationResult(success: success, error: error)
    }
}
