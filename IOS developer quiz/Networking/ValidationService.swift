//
//  RedistrationApiService.swift
//  IOS developer quiz
//
//  Created by Oleg on 19.04.2021.
//

import Foundation
import Combine

protocol PValidationService {
    func checkUsername(_ username: String) -> AnyPublisher<CheckDTO, CheckError>
}