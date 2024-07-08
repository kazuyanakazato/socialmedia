//
//  NewPostView.swift
//  SocialMedia
//
//  Created by Kazuya Nakazato on 2024/06/03.
//

import Foundation
import SwiftUI
import Firebase

struct NewPostView: View {
    @State private var content = ""
    @Environment(\.presentationMode) var presentationMode
    
    private var db = Firestore.firestore()
    
    var body: some View {
        VStack {
            TextField("What's on your mind?", text: $content)
                .padding()
            
            Button("Post") {
                let newPost = [
                    "userId": Auth.auth().currentUser?.uid ?? "",
                    "content": content,
                    "timestamp": Timestamp()
                ] as [String : Any]
                
                db.collection("posts").addDocument(data: newPost) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully")
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    NewPostView()
}
