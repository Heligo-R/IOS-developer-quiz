//
//  CheckDTO.swift
//  IOS developer quiz
//
//  Created by Oleg on 19.04.2021.
//

enum CheckError: Error {
    case error(String)
}

struct CheckDTO: Decodable {
    let valid: Bool
    let message: String?
}
