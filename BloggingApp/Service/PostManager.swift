//
//  PostManager.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import Foundation

import Foundation
import FirebaseCore
import FirebaseFirestore

protocol PostManagerDelegate {
    func didUpdatePosts()
}

final class PostManager {
    
    let db = Firestore.firestore()
    var delegate: PostManagerDelegate?
    var posts = [Post]()
    
    func post(message: String, user: User) {
        var ref: DocumentReference? = nil
        let date = Date.now
        let timeInterval = String(describing: date.timeIntervalSince1970)
        ref = db.collection("users/\(user.id)/posts").addDocument(data:
        ["message": message,
         "date": timeInterval]) { [weak self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self?.fetchPosts(forUser: user)
            }
        }
    }
    
    func fetchPosts(forUser user: User) {
        db.collection("users/\(user.id)/posts").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self?.posts = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let message = data["message"] as? String else { return }
                    guard let timeInterval = Double(data["date"] as! Substring) else { return }
                    let date = Date(timeIntervalSince1970: timeInterval)
                    let post = Post(message: message,
                                    date: date)
                    self?.posts.append(post)
                }
            }
            self?.delegate?.didUpdatePosts()
        }
    }
}
