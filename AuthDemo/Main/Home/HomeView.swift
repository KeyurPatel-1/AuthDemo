//
//  HomeView.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import SwiftUI
import LocalAuthentication

struct HomeView: View {
    @EnvironmentObject var navigationState: NavigationState

    @State private var authenticationFailed: Bool = false
    @ObservedObject var viewModel: HomeViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.timestamp, ascending: true)],
        animation: .default)
    private var user: FetchedResults<User>
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Welcome, \(user.first?.fullName ?? "Alex")")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(Color.primaryTextColor)
                .padding()
            
            
            HStack {
                Text("Enable Biometric Authentication")
                    .font(.subheadline)
                Spacer()
                Toggle("", isOn: $viewModel.isBiometricEnabled)
                    .labelsHidden()
                    .onChange(of: viewModel.isBiometricEnabled) { newValue in
                        viewModel.handleBiometricToggle(newValue) { success in
                            if !success {
                                authenticationFailed = true
                            }
                        }
                    }
            }
            .padding(.horizontal)

            Spacer()

            // Logout Button
            CustomButton(title: "Logout", backgroundColor: Color.primaryColor, isLoading: false, isDisable: false) {
                viewModel.logoutAction()
                navigationState.logOutUser()
            }
        }
        .padding()
        .navigationTitle("Home")
        .onAppear {
            viewModel.authenticateIfNeeded { success in
                if !success {
                    authenticationFailed = true
                }
            }
        }
        .alert(isPresented: $authenticationFailed) {
            Alert(
                title: Text("Authentication Failed"),
                message: Text("Please try again."),
                dismissButton: .default(Text("OK"), action: {
                    viewModel.authenticateIfNeeded { _ in }
                })
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
