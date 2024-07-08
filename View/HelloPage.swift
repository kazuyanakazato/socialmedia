//
//  HelloPage.swift
//  SocialMedia
//
//  Created by Kazuya Nakazato on 2024/06/10.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct HelloPage: View {
    var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Hello, you're logged in!!")
                .padding()
            Button("Log Out") {
                viewModel.signOut()
            }
        }
    }
}

