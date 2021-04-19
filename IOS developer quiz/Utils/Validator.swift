//
//  Validator.swift
//  IOS developer quiz
//
//  Created by Oleg on 19.04.2021.
//

import Foundation
import Combine

final class Validator {
    private var validationService: PValidationService
    
    init(service: PValidationService) {
        validationService = service
    }
    
    func validateUsernameRemotely(_ username: String) -> AnyPublisher<TFValidation, Never> {
        if username != "" {
            return validationService.checkUsername(username).map { result -> TFValidation in
                if result.valid {
                    return .valid
                } else if let message = result.message {
                    return .invalid(message)
                } else {
                    return .empty
                }
            }
            .catch { error -> Just<TFValidation> in
                switch error {
                case .error(let message):
                    return Just(.invalid(message))
                }
            }
            .eraseToAnyPublisher()
        } else {
            return Just(.empty)
                .eraseToAnyPublisher()
        }
    }
    
    func validatePassword(_ password: String) -> TFValidation {
        switch true {
        case password == "":
            return .empty
        case password.count <= 8:
            return .invalid("Password length must be greater than 8 chars")
        case checkPasswordForWellKnownPasses(password) != true:
            return .invalid("Well-known passwords are prohibited")
        default:
            return .valid
        }
    }
    
    func validateVerifyPassword(verifyPassword: String, password: String) -> TFValidation {
        switch verifyPassword {
        case "":
            return .empty
        case password:
            return .valid
        default:
            return .invalid("Passwords must match")
        }
    }
    
    func checkPasswordForWellKnownPasses(_ password: String) -> Bool {
        let prohibitedWellKnownPasswords = ["password", "admin"]
        return prohibitedWellKnownPasswords.allSatisfy({ !password.contains($0) })
    }
}
