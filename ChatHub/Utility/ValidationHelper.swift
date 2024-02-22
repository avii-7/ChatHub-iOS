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

struct ValidationHelper {
    
    static func validate(email: String?, pass: String?) -> ValidationResult {
        
        let validationResult: ValidationResult
        
        if email == nil || email!.isEmpty {
            validationResult = ValidationResult(success: false, error: "Email address can't be empty.")
        }
        else if pass == nil || pass!.isEmpty {
            validationResult = ValidationResult(success: false, error: "Password can't be empty.")
        }
        else{
            validationResult = ValidationResult(success: true)
        }
        
        return validationResult
    }
    
}
