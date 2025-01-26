//
//  NavigationStateView.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import SwiftUI

struct NavigationStateView: View {
    @StateObject private var navigationState = NavigationState()
    
    var body: some View {
        Group {
            switch navigationState.authState {
           
            case .notAuthenticated:
                NavigationView {
                    LoginView(viewModel: .init())
                }
                .environmentObject(navigationState)
           
            case .authenticated:
                NavigationView {
                    HomeView(viewModel: .init())
                }
                .environmentObject(navigationState)

            }
        }
    }

}

