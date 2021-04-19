//
//  Validator.swift
//  IOS developer quiz
//
//  Created by Oleg on 19.04.2021.
//

import Combine

enum Validation: Equatable {
    case valid
    case invalid(String)
    case none
}

final class Validator {
    private var validationService: PValidationService
    
    init(service: PValidationService) {
        validationService = service
    }
    
    func validateUsernameRemotely(_ username: String) -> AnyPublisher<Validation, Never> {
        guard username != "" else {
            return Just(.none)
                .eraseToAnyPublisher()
        }
        return validationService.checkUsername(username).map { result -> Validation in
            if result.valid {
                return .valid
            } else if let message = result.message {
                return .invalid(message)
            } else {
                return .none
            }
        }
        .catch { error -> Just<Validation> in
            switch error {
            case .error(let message):
                return Just(.invalid(message))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func validatePassword(_ password: String) -> Validation {
        if password == "" {
            return .none
        } else if password.count <= 8 {
            return .invalid("Password length must be greater than 8 chars")
        } else if checkPasswordForWellKnownPasses(password) != true {
            return .invalid("Well-known passwords are prohibited")
        } else {
            return .valid
        }
    }
    
    func validateConfirmPassword(confirmPassword: String, password: String) -> Validation {
        switch confirmPassword {
        case "":
            return .none
        case password:
            return .valid
        default:
            return .invalid("Passwords must match")
        }
    }
    
    func checkPasswordForWellKnownPasses(_ password: String) -> Bool {
        let prohibitedWellKnownPasswords = ["password", "admin"]
        return prohibitedWellKnownPasswords.allSatisfy { !password.contains($0) }
    }
}
