//
//  AuthDemoApp.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import SwiftUI

@main
struct AuthDemoApp: App {
    static let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStateView()
                .environment(\.managedObjectContext, AuthDemoApp.persistenceController.container.viewContext)
        }
    }
}


