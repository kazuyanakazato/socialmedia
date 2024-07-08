//
//  LoginView.swift
//  SocialMedia
//
//  Created by Kazuya Nakazato on 2024/06/03.
//

import Foundation
import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .padding()

                SecureField("Password", text: $password)
                    .padding()

                // ログイン成功時に、同時にデータベースへのアクセス処理を明示的に入れること（未実装）
                Button("Log In") {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        DispatchQueue.main.async {
                            if let user = result?.user, error == nil {
                                self.viewModel.isAuthenticated = true
                                self.viewModel.currentUser = user
                            } else {
                                print("Failed to sign in: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                    }
                }
                .padding()

                NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                    Text("Create Account")
                }
                
                if let currentUser = viewModel.currentUser {
                    Text("Logged in as: \(currentUser.uid)")
                }
            }
            .navigationTitle("Log in")
        }
        
    }
}
