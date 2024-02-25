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
    func validate(name: String?, email: String?, pass: String?) -> ValidationResult
    func validate(email: String?, pass: String?) -> ValidationResult
}

struct CredentialValidatorHelper : CredentialValidator{
    
    func validate(name: String?, email: String?, pass: String?) -> ValidationResult {
        
        if name == nil || name!.isEmpty {
            return .init(success: false, error: "name can't be empty")
        }
        
        return validate(email: email, pass: pass)
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
