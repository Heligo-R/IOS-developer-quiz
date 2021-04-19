//
//  RegistrationView.swift
//  IOS developer quiz
//
//  Created by Oleg on 17.04.2021.
//

import SwiftUI

struct RegistrationView<VM: PRegistrationViewModel>: View {
    @EnvironmentObject private var viewModel: VM
    
    var registrationFormView: some View {
        VStack(spacing: 16.0) {
            usernameField
            passwordField
            confirmPasswordField
            createAccountButton
        }
        .padding(.vertical, 25.0)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(20.0)
    }
    
    var usernameField: some View  {
        TextField("Username", text: $viewModel.username)
            .textFieldStyle(ValidatableTextFieldStyle(validation: viewModel.usernameValidation))
    }
    
    var passwordField: some View  {
        SecureField("Password", text: $viewModel.password)
            .textFieldStyle(ValidatableTextFieldStyle(validation: viewModel.passwordValidation))
    }
    
    var confirmPasswordField: some View  {
        SecureField("Confirm password", text: $viewModel.confirmPassword)
            .textFieldStyle(ValidatableTextFieldStyle(validation: viewModel.confirmPasswordValidation))
    }
    
    var createAccountButton: some View  {
        Button("Create Account", action: viewModel.register)
            .disabled(viewModel.isRegistrationDisabled)
            .padding(10.0)
            .background(VerticalGradientView.defaultGradientView())
            .accentColor(.white)
            .cornerRadius(20.0)
    }
    
    var body: some View {
        ZStack {
            VerticalGradientView.defaultGradientView()
            VStack {
                Image("swiftui-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150.0)
                Text("Sign up")
                    .font(.title)
                    .foregroundColor(Color.white)
                registrationFormView
                    .padding()
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView<RegistrationViewModel>().environmentObject(RegistrationViewModel(service: MockValidationService()))
    }
}
