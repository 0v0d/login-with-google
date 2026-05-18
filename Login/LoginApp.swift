//
// LoginApp.swift
//  login
//
//  Created by 0v0 on 2026/05/18.
//

import FirebaseCore
import GoogleSignIn
import SwiftUI

@main
struct LoginApp: App {
    @State private var viewModel: AuthViewModel

    init() {
        FirebaseApp.configure()
        _viewModel = State(initialValue: AuthViewModel())
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if let user = viewModel.user {
                    MainView(user: user)
                } else {
                    LoginView()
                }
            }.environment(viewModel)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
