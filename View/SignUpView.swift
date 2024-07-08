//
//  SignUpView.swift
//  SocialMedia
//
//  Created by Kazuya Nakazato on 2024/06/08.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
            
            SecureField("Password", text: $password)
                .padding()
            
            Button("Sign Up") {
                viewModel.signUp(email: email, password: password)
            }
            .padding()
            
            if viewModel.isAuthenticated {
                if viewModel.isAuthenticated {
                    HelloPage(viewModel: viewModel)
                }
            }
        }
    }
}

