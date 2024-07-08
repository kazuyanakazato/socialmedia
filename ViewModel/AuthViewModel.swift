//
//  AuthViewModel.swift
//  SocialMedia
//
//  Created by Kazuya Nakazato on 2024/06/08.
//

import SwiftUI
import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: FirebaseAuth.User?
    weak var delegate: AuthUIDelegate?
    
    init() {
            observeAuthChanges()
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
                self?.currentUser = user
            }
            
        }
    }
    
    // ログインするメソッド
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self]
            result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.isAuthenticated = true
                    self?.currentUser = Auth.auth().currentUser
                } else {
                    print("Failed to sign in: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    // 新規登録するメソッド
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self]
            result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    func resetPassword(email: String) {
        
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else { return self.displayError(error) }
            // self.delegate?.lastLoginDate
        }
    }
    
    func displayError(_ error: Error?) {
        if error != nil {
            print("Error: ")
        }
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.currentUser = nil
            }
        }
        catch let error as NSError {
            print("Error sighing out: \(error.localizedDescription)")
        }
    }
}
