//
//  RegistrationViewModel.swift
//  IOS developer quiz
//
//  Created by Oleg on 18.04.2021.
//

import Foundation
import Combine

enum TFValidation: Equatable {
    case valid
    case invalid(String)
    case empty
}

protocol PRegistrationViewModel: ObservableObject {
    var username: String { get set }
    var password: String { get set }
    var verifyPassword: String { get set }
    
    var isRegistrationDisabled: Bool { get }
    var usernameValidation: TFValidation { get }
    var passwordValidation: TFValidation { get }
    var verifyPasswordValidation: TFValidation { get }
    
    func register()
}

final class RegistrationViewModel: PRegistrationViewModel {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var verifyPassword: String = ""
    
    var isRegistrationDisabled: Bool {
        !(usernameValidation == .valid && passwordValidation == .valid && verifyPasswordValidation == .valid)
    }
    
    @Published var usernameValidation: TFValidation = .empty
    @Published var passwordValidation: TFValidation = .empty
    @Published var verifyPasswordValidation: TFValidation = .empty
    
    private let registrationService: PRegistrationService
    private var disposeSet = Set<AnyCancellable>()
    
    init(service: PRegistrationService) {
        self.registrationService = service
        
        subscribeOnFieldChanges()
    }
    
    private func subscribeOnFieldChanges() {
        $username
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weak self] value -> AnyPublisher<TFValidation, Never> in
                if value == "" {
                    return Just(.empty)
                        .eraseToAnyPublisher()
                } else if let strongSelf = self {
                    return strongSelf.registrationService.checkUsername(value).map { result -> TFValidation in
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
            .assign(to: \.usernameValidation, on: self)
            .store(in: &disposeSet)
        
        $password
            .map { [weak self] value -> TFValidation in
            switch true {
            case value == "":
                return .empty
            case value.count <= 8:
                return .invalid("Password length must be greater than 8 chars")
            case self?.checkPassword(value) != true:
                return .invalid("Well-known passwords are prohibited")
            default:
                return .valid
            }
        }
        .assign(to: \.passwordValidation, on: self)
        .store(in: &disposeSet)
        
        $verifyPassword
            .combineLatest($password)
            .map { (verifyPassword, password) -> TFValidation in
                switch verifyPassword {
                case "":
                    return .empty
                case password:
                    return .valid
                default:
                    return .invalid("Passwords must match")
                }
            }
            .assign(to: \.verifyPasswordValidation, on: self)
            .store(in: &disposeSet)
    }
    
    private func checkPassword(_ password: String) -> Bool {
        let prohibitedWellKnownPasswords = ["password", "admin"]
        return prohibitedWellKnownPasswords.allSatisfy({ !password.contains($0) })
    }
    
    func register() {
    }
}
