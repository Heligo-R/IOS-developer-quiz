//
//  ContentView.swift
//  IOS developer quiz
//
//  Created by Oleg on 17.04.2021.
//

import SwiftUI

struct GradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.purple, .blue]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).edgesIgnoringSafeArea(.all)
    }
}

enum Validation: Equatable {
    case valid
    case invalid(String)
    case empty
}

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

struct RegistrationFormView<VM: PRegistrationViewModel>: View {
    @EnvironmentObject private var viewModel: VM
        
    var body: some View {
        VStack(spacing: 16.0) {
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(ValidatableTextFieldStyle(validation: viewModel.usernameValidation))
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(ValidatableTextFieldStyle(validation: viewModel.passwordValidation))
            SecureField("Verify password", text: $viewModel.verifyPassword)
                .textFieldStyle(ValidatableTextFieldStyle(validation: viewModel.verifyPasswordValidation))
            Button("Create Account", action: viewModel.register)
                .disabled(viewModel.isRegistrationDisabled)
                .padding(10.0)
                .background(GradientView())
                .accentColor(.white)
                .cornerRadius(20.0)
        }
        .padding(.vertical, 25.0)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(20.0)
    }
}

struct ContentView<VM: PRegistrationViewModel>: View {    
    var body: some View {
        ZStack {
            GradientView()
            VStack {
                Image("swiftui-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150.0)
                Text("Sign up")
                    .font(.title)
                    .foregroundColor(Color.white)
                RegistrationFormView<VM>()
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<RegistrationViewModel>().environmentObject( RegistrationViewModel(service: MockRegistrationService()))
    }
}
