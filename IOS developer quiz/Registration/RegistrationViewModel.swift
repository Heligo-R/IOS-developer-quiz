//
//  RegistrationViewModel.swift
//  IOS developer quiz
//
//  Created by Oleg on 18.04.2021.
//

import Foundation
import Combine

protocol PRegistrationViewModel: ObservableObject {
    var username: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }
    
    var isRegistrationDisabled: Bool { get }
    var usernameValidation: Validation { get }
    var passwordValidation: Validation { get }
    var confirmPasswordValidation: Validation { get }
    
    func register()
}

final class RegistrationViewModel: PRegistrationViewModel {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    var isRegistrationDisabled: Bool {
        !(usernameValidation == .valid && passwordValidation == .valid && confirmPasswordValidation == .valid)
    }
    
    @Published var usernameValidation: Validation = .none
    @Published var passwordValidation: Validation = .none
    @Published var confirmPasswordValidation: Validation = .none
    
    private let validator: Validator
    private var disposeSet = Set<AnyCancellable>()
    
    init(service: PValidationService) {
        validator = Validator(service: service)
        
        subscribeOnFieldChanges()
    }
    
    private func subscribeOnFieldChanges() {
        $username
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap(validator.validateUsernameRemotely)
            .assign(to: \.usernameValidation, on: self)
            .store(in: &disposeSet)
        
        $password
            .map(validator.validatePassword)
            .assign(to: \.passwordValidation, on: self)
            .store(in: &disposeSet)
        
        $confirmPassword
            .combineLatest($password)
            .map(validator.validateConfirmPassword)
            .assign(to: \.confirmPasswordValidation, on: self)
            .store(in: &disposeSet)
    }
    
    func register() {
    }
}
