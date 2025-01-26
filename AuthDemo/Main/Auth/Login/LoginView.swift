//
//  LoginView.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @EnvironmentObject var navigationState: NavigationState
    
    @ObservedObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        self.bodyWithoutModifier()
            .navigationBarHidden(true)
    }
    
    @ViewBuilder
    func bodyWithoutModifier() -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 32) {
                Image(.smallLogo)
                
                Text("Sign in to your account")
                    .foregroundStyle(Color.primaryColor)
                    .font(.system(size: 20, weight: .semibold, design: .default))
                
                
                self.formTextField()
                    .padding(.top, 16)
                
                self.actionButton()
                    .padding(.top, 16)
                
                self.createAccount()
            }
            .padding()
        }
    }

    @ViewBuilder
    func formTextField() -> some View {
        VStack(alignment: .center, spacing: 16) {

            CustomTextField(
                binding: self.$viewModel.txtEmail,
                placeHolder: "Enter your email address",
                infos: emailInfos,
                isSecure: false,
                leftView: nil,
                rightView: nil
            )
            .keyboardType(.emailAddress)
            .onChange(of: viewModel.txtEmail) { _,_ in
                self.viewModel.emailError = !self.viewModel.txtEmail.isValidEmail ? "Please enter valid email" : ""
            }
            
            CustomTextField(
                binding: self.$viewModel.txtPassword,
                placeHolder: "Enter your password*",
                infos: [
                    .init(position: .top, text: "Password")
                ],
                isSecure: !self.viewModel.isShowPasswordText,
                leftView: nil,
                rightView: AnyView(
                    Button(action: {
                        self.viewModel.togglePasswordText()
                    }, label: {
                        Image(self.viewModel.isShowPasswordText ? .eyeOff : .eyeOpen)
                            .foregroundStyle(Color.secondaryTextColor)
                    })
                )
            )
        }
    }
    
    @ViewBuilder
    func actionButton() -> some View {
        CustomButton(
            title: "Sign In",
            backgroundColor: .primaryColor,
            isLoading: self.viewModel.isLoading,
            isDisable: !self.viewModel.isValidField
        ) {
            self.viewModel.isLoading = true
            Task {
                let response = await self.viewModel.loginButtonAction()
                if response {
                    navigationState.goToHomeScreen()
                }
            }
        }
    }
    
    @ViewBuilder
    func createAccount() -> some View {
        HStack(spacing: 8) {
            Text("Don’t have an account?")
                .foregroundStyle(Color.secondaryTextColor)
                .font(.system(size: 12, weight: .regular, design: .default))
            
            NavigationLink(destination: SignupView(viewModel: .init())) {
                
                Button(action: {}, label: {
                    Text("Create Account")
                        .foregroundStyle(Color.primaryColor)
                        .font(.system(size: 12, weight: .semibold, design: .default))
                })
                .disabled(true)
            }

        }
    }
    
}

extension LoginView {
    var emailInfos: [CustomTextField.Info] {
        var infos: [CustomTextField.Info] = [.init(position: .top, text: "Email Address*")]
        if !self.viewModel.emailError.isEmpty {
            infos.append(.init(position: .error, text: self.viewModel.emailError))
        }
        return infos
    }
}

#Preview {
    LoginView(viewModel: .init())
}


