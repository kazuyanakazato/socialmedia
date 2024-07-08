//
//  MyPageView.swift
//  SocialMedia
//
//  Created by Kazuya Nakazato on 2024/07/04.
//

import Foundation
import SwiftUI
import Firebase

struct UserProfile {
    var name: String
    var username: String
    var bio: String
    var profileImageUrl: String?
}

class UserProfileViewModel: ObservableObject {
    @Published var userProfile = UserProfile(
        name: "User Name",
        username: "username",
        bio: "This is a bio",
        profileImageUrl: nil
    )
    
    func fetchUserProfile(userId: String) {
        //ユーザープロフィール情報を取得するロジックを追加
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document {
                print("thissss: \(userId)")
                let data = document.data()
                // データがuid紐付けで取得できていない。なぜか要解明。
                print("thissssxx: \(String(describing: data))")
                self.userProfile = UserProfile(
                    name: data?["name"] as? String ?? "",
                    username: data?["username"] as? String ?? "",
                    bio: data?["bio"] as? String ?? "adsdddd",
                    profileImageUrl: data?["profileImageUrl"] as? String
                )
            } else {
                print("Document does not exist")
            }
        }
    }
}

struct UserProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if let imageUrl = viewModel.userProfile.profileImageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            Text(viewModel.userProfile.name)
                .font(.title)
            Text("@\(viewModel.userProfile.username)")
                .foregroundColor(.gray)
            Text(viewModel.userProfile.bio)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

class UserPostsViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    func fetchUserPosts(userId: String) {
        // 特定のユーザーの投稿を取得するロジックを追加
        let db = Firestore.firestore()
        db.collection("posts").whereField("userId", isEqualTo: userId).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.posts = querySnapshot.documents.map { document in
                    let data = document.data()
                    return Post(
                        id: document.documentID,
                        age: data["age"] as? Int ?? 0,
                        birthplace: data["birthplace"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        post: data["post"] as? String ?? "",
                        residence: data["residence"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                        username: data["username"] as? String ?? ""
                    )
                }
            } else {
                print("Error getting documents: \(error?.localizedDescription ?? "Unknown error")")
            }
            
        }
    }
}

struct userPostsView: View {
    @ObservedObject var viewModel: UserPostsViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.posts) { post in
                PostView(post: post)
                    .listRowSeparator(.hidden)
            }
        }
    }
}

struct MyPageView: View {
    @ObservedObject var userProfileViewModel = UserProfileViewModel()
    @ObservedObject var userPostsViewModel = UserPostsViewModel()
    var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let user = viewModel.currentUser {
                        Text("User ID: \(user.uid)")
                            .font(.headline)
                            .padding()
                    }
                    // ユーザープロフィール情報の表示
                    UserProfileView(viewModel: userProfileViewModel)
                    // ユーザー投稿情報の表示
                    userPostsView(viewModel: userPostsViewModel)
                }
            }
            .navigationTitle("My Page")
            .onAppear {
                // 現在ログインしているユーザーのUIDを使用してデータを取得
                if let userId = viewModel.currentUser?.uid {
                    print("test code: \(userId)")
                    self.userProfileViewModel.fetchUserProfile(userId: userId)
                    self.userPostsViewModel.fetchUserPosts(userId: userId)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log Out") {
                        viewModel.signOut()
                    }
                }
            }
        }
    }
}
