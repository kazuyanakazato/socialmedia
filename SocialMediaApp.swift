//
//  SocialMediaApp.swift
//  SocialMedia
//
//  Created by Kazuya Nakazato on 2024/06/03.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SocialMediaApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            // ログイン状態によって画面遷移するページを変更する
            if viewModel.isAuthenticated {
                TimeLineView(viewModel: viewModel)
                //HelloPage(viewModel: viewModel)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
    }
}
