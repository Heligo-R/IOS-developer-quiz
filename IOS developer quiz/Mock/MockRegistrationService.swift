//
//  MockRegistrationService.swift
//  IOS developer quiz
//
//  Created by Oleg on 19.04.2021.
//

import Foundation
import Combine

final class MockRegistrationService: PRegistrationService {
    func checkUsername(_ username: String) -> AnyPublisher<CheckDTO, CheckError> {
        Just(username).map { value -> CheckDTO in
            let isValid = value.count > 5
            let message = isValid ? nil : "Username must longer than 5 chars"
            return CheckDTO(valid: isValid, message: message)
        }
        .setFailureType(to: CheckError.self)
        .eraseToAnyPublisher()
    }
}
