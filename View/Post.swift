//
//  Post.swift
//  SocialMedia
//
//  Created by Kazuya Nakazato on 2024/06/03.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var age: Int
    var birthplace: String
    var name: String
    var post: String
    var residence: String
    var timestamp: Date
    var username: String
    /*
    var userId: String
    var content: String
    var password: String?
    var auther: String
    */
}

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    private var db = Firestore.firestore()
    
    func fetchPosts() {
        
        db.collection("user").order(by: "timestamp", descending: true).addSnapshotListener { (querySnapshot, error) in
            print("Query snapshot received. Document count: \(querySnapshot?.documents.count ?? 0)")
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            print(self.posts)
            self.posts = documents.compactMap { QueryDocumentSnapshot in
                do {
                    let data = QueryDocumentSnapshot.data()
                    print("Document data: \(data)")
                    let post = try QueryDocumentSnapshot.data(as: Post.self)
                    print("Successfully decoded post: \(post)")
                    return post
                } catch {
                    print("Error decoding document \(QueryDocumentSnapshot.documentID): \(error)")
                    return nil
                }
                //try? QueryDocumentSnapshot.data(as: Post.self)
            }
            print("Final posts count: \(self.posts.count)")
            
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
        }
        print("Fetched posts: \(self.posts.count)")
        self.posts.forEach { post in
            print("Post: \(post)")
        }
    }
}

/*
struct FeedView: View {
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        List(viewModel.posts) { post in
            VStack(alignment: .leading) {
                Text(post.content)
                Text(post.timestamp.dateValue(), style: .time)
                        .font(.subheadline)
                        .foregroundColor(.gray)
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
    }
}
*/
