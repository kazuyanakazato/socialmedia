//
//  TimeLineView.swift
//  SocialMedia
//
//  Created by Kazuya Nakazato on 2024/06/15.
//

import Foundation
import SwiftUI

struct PostView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                //プロフィール画像
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
                VStack(alignment: .leading, spacing: 4) {
                    //ユーザー情報と投稿時間
                    HStack {
                        Text(post.name)
                            .font(.headline)
                        Text("@\(post.username)")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(post.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    //投稿内容
                    Text(post.post)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Divider()
                    //アクションボタン
                    HStack(spacing: 40) {
                        Button(action: { /* 返信アクション */ }) {
                            Image(systemName: "bubble.left")
                        }
                        Button(action: { /* リツイートアクション */ }) {
                            Image(systemName: "arrow.2.squarepath")
                        }
                        Button(action: { /* いいねアクション */ }) {
                            Image(systemName: "heart")
                        }
                        Button(action: { /* 共有アクション */ }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    .foregroundColor(.gray)
                }
            }
            Divider()
        }
        .padding(.vertical, 8)
    }
}

struct TimeLineView: View {
    @ObservedObject var postViewModel = PostViewModel()
    @State private var isShowingTweetSheet = false
    var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    ForEach(postViewModel.posts) { post in
                        PostView(post: post)
                            //.listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                    }
                }
                //.listStyle(PlainListStyle())
                .navigationTitle("TimeLine")
                .onAppear {
                    self.postViewModel.fetchPosts()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: MyPageView(viewModel: viewModel)) {
                            Text("My Page")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Log Out") {
                            viewModel.signOut()
                        }
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        //Tweetボタンのアクション
                        isShowingTweetSheet.toggle()
                    }) {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $isShowingTweetSheet) {
            // pop-up view when the tweet button is pushed
            TweetSheetView(isPresented: $isShowingTweetSheet)
                .frame(width: 300, height: 200)
                .background(Color.clear)
                .padding(20)
        }
    }
}

struct TweetSheetView: View {
    @Binding var isPresented: Bool
    @State private var tweettext = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Compose Tweet")
                .font(.title)
                .padding()
            
            TextField("What's happening??", text: $tweettext)
                .padding()
                .frame(height: 120)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(0)
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Tweet") {
                    // Action after the button is pushed
                    print("Tweeting: \(tweettext)")
                    isPresented.toggle() // close after posted tweet
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}
