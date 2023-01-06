//
//  FollowersManager.swift
//  BloggingApp
//
//  Created by Анастасия on 06.01.2023.
//

import Foundation
import FirebaseFirestore

protocol FollowManagerDelegate {
    func didFetchFollowers()
    func didFetchSubscriptions()
}

final class FollowManager {
    
    private var user: User
    var delegate: FollowManagerDelegate?
    
    private var subscribtions = [String]()
    private var followers = [String]()
    
    init(user: User) {
        self.user = user
        fetchFollowers()
        fetchSubscriptions()
    }
    
    func fetchFollowers() {
        let db = Firestore.firestore()
        db.collection("users/\(user.id)/followers").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self?.followers = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let id = data["id"] as? String else { return }
                    self?.followers.append(id)
                }
                self?.delegate?.didFetchFollowers()
            }
        }
    }
    func fetchSubscriptions() {
        let db = Firestore.firestore()
        db.collection("users/\(user.id)/subscriptions").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self?.subscribtions = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let id = data["id"] as? String else { return }
                    self?.subscribtions.append(id)
                }
                self?.delegate?.didFetchSubscriptions()
            }
        }
    }
    
    func getFollowers() -> [String] {
        return followers
    }
    
    func getSubscriptions() -> [String] {
        return subscribtions
    }
    
    func follow(userWithId id: String) {
        let db = Firestore.firestore()
        db.collection("users/\(user.id)/subscriptions").addDocument(data:
        ["id": id]) { [weak self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self?.fetchFollowers()
                self?.addFollower(toUserWithId: id)
            }
        }
    }
    
    func addFollower(toUserWithId id: String) {
        let db = Firestore.firestore()
        db.collection("users/\(id)/followers").addDocument(data: [
            "id": user.id
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
}
