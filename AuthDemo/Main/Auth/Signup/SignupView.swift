//
//  SignupView.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var navigationState: NavigationState
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SignupViewModel
    
    init(viewModel: SignupViewModel) {
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
                
                Text("Crete new account")
                    .foregroundStyle(Color.primaryColor)
                    .font(.system(size: 20, weight: .semibold, design: .default))
                
                
                self.formTextField()
                
                self.actionButton()
                    .padding(.top, 16)
                
                self.alreadyAccount()
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func formTextField() -> some View {
        VStack(spacing: 20) {
            
            
            CustomTextField(
                binding: self.$viewModel.txtFullName,
                placeHolder: "Enter full name",
                infos: [
                    .init(position: .top, text: "Enter Name*")
                ],
                isSecure: false
            )
            
            
            CustomTextField(
                binding: self.$viewModel.txtEmail,
                placeHolder: "Enter email",
                infos: emailInfos
            )
            .keyboardType(.emailAddress)
            .onChange(of: viewModel.txtEmail) { _,_ in
                self.viewModel.emailError = !self.viewModel.txtEmail.isValidEmail ? "Please enter valid email" : ""
            }
            
            CustomTextField(
                binding: self.$viewModel.txtPassword,
                placeHolder: "Enter password",
                infos: passwordInfos,
                isSecure: !self.viewModel.isShowPasswordText,
                rightView: AnyView(
                    Button(action: {
                        self.viewModel.togglePasswordText()
                    }, label: {
                        Image(self.viewModel.isShowPasswordText ? .eyeOff : .eyeOpen)
                            .foregroundStyle(Color.secondaryTextColor)
                    })
                )
            )
            .onChange(of: viewModel.txtPassword) { _,_ in
                self.viewModel.passwordError = PasswordValidator().invalidMessage(value: viewModel.txtPassword)
            }
            
            CustomTextField(
                binding: self.$viewModel.txtConfirmPassword,
                placeHolder: "Enter confirm password",
                infos: confirmPasswordInfos,
                isSecure: !self.viewModel.isShowConfirmPasswordText,
                rightView: AnyView(
                    Button(action: {
                        self.viewModel.toggleConfirmPasswordText()
                    }, label: {
                        Image(self.viewModel.isShowConfirmPasswordText ? .eyeOff : .eyeOpen)
                            .foregroundStyle(Color.secondaryTextColor)
                    })
                )
            )
            .onChange(of: viewModel.txtConfirmPassword) { _,_ in
                self.viewModel.confirmPasswordError =  viewModel.txtConfirmPassword != viewModel.txtPassword ? "password and confir password do not match" : ""
            }
            
            let minDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
            
            DatePicker(
                selection: self.$viewModel.selectedDateOfBirth,
                in: ...minDate,
                displayedComponents: [.date]) {
                    Text("Select Date of birth*")
                        .foregroundStyle(Color.secondaryTextColor)
                        .font(.system(size: 14, weight: .semibold, design: .default))
                }
            
            
            HStack(alignment: .center) {
                Text("Gender*")
                    .foregroundStyle(Color.secondaryTextColor)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                
                Spacer()
                
                Picker("", selection: $viewModel.txtGender) {
                    Group {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundStyle(Color.secondaryTextColor)
                }
                .pickerStyle(.palette)
            }
            
            
        }
    }
    
    @ViewBuilder
    func actionButton() -> some View {
        CustomButton(
            title: "Sign up",
            backgroundColor: .primaryColor,
            isLoading: self.viewModel.isLoading,
            isDisable: !self.viewModel.isValidField
        ) {
            self.viewModel.isLoading = true
            Task {
                let response = await self.viewModel.signupButtonAction()
                if response {
                    navigationState.goToHomeScreen()
                }
            }
        }
    }
    
    @ViewBuilder
    func alreadyAccount() -> some View {
        HStack(spacing: 8) {
            Text("Already have an account?")
                .foregroundStyle(Color.secondaryTextColor)
                .font(.system(size: 12, weight: .regular, design: .default))
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Back to Sign In")
                    .foregroundStyle(Color.primaryColor)
                    .font(.system(size: 12, weight: .semibold, design: .default))
            })
            
        }
    }
}

extension SignupView {
    var emailInfos: [CustomTextField.Info] {
        var infos: [CustomTextField.Info] = [.init(position: .top, text: "Email Address*")]
        if !self.viewModel.emailError.isEmpty {
            infos.append(.init(position: .error, text: self.viewModel.emailError))
        }
        return infos
    }
    
    var passwordInfos: [CustomTextField.Info] {
        var infos: [CustomTextField.Info] = [.init(position: .top, text: "Enter password*")]
        if !self.viewModel.passwordError.isEmpty {
            infos.append(.init(position: .error, text: self.viewModel.passwordError))
        }
        return infos
    }
    
    var confirmPasswordInfos: [CustomTextField.Info] {
        var infos: [CustomTextField.Info] = [.init(position: .top, text: "Enter confirm password*")]
        if !self.viewModel.confirmPasswordError.isEmpty {
            infos.append(.init(position: .error, text: self.viewModel.confirmPasswordError))
        }
        return infos
    }
}

#Preview {
    SignupView(viewModel: .init())
}
