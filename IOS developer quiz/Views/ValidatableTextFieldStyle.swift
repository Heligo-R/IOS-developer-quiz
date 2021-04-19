//
//  ValidatableTextField.swift
//  IOS developer quiz
//
//  Created by Oleg on 19.04.2021.
//

import SwiftUI

struct ValidatableTextFieldStyle: TextFieldStyle {
    var validation: Validation
    var borderColor: Color {
        switch validation {
        case .invalid(_):
            return .red
        default:
            return .gray
        }
    }
    
    func _body(configuration: TextField<_Label>) -> some View {
        VStack {
            configuration
                .padding(5.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 4.0)
                        .stroke(borderColor, lineWidth: 0.5)
                )
            switch validation {
            case .invalid(let message):
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
            default:
                EmptyView()
            }
        }
    }
}

struct ValidatableTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextField("Valid field", text: .constant(""))
                .textFieldStyle(ValidatableTextFieldStyle(validation: .valid))
            TextField("Invalid field", text: .constant(""))
                .textFieldStyle(ValidatableTextFieldStyle(validation: .invalid("Something wrong")))
        }
        .padding()
    }
}
