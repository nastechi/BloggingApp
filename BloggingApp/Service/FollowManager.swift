//
//  FollowersManager.swift
//  BloggingApp
//
//  Created by Анастасия on 06.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

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
        fetchFollowers(forId: user.id)
        fetchSubscriptions(forId: user.id)
    }
    
    func fetchFollowers(forId id: String) {
        let db = Firestore.firestore()
        db.collection("users/\(id)/followers").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self?.followers = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let strangerId = data["id"] as? String else { return }
                    self?.followers.append(strangerId)
                }
                self?.delegate?.didFetchFollowers()
            }
        }
    }
    func fetchSubscriptions(forId id: String) {
        let db = Firestore.firestore()
        db.collection("users/\(id)/subscriptions").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self?.subscribtions = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let strangerId = data["id"] as? String else { return }
                    self?.subscribtions.append(strangerId)
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
                if let myId = self?.user.id {
                    self?.fetchFollowers(forId: myId)
                }
                self?.addFollower(toUserWithId: id)
            }
        }
    }
    
    private func addFollower(toUserWithId id: String) {
        let db = Firestore.firestore()
        db.collection("users/\(id)/followers").addDocument(data: [
            "id": user.id
        ]) { [weak self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self?.fetchFollowers(forId: id)
            }
        }
    }
    
    func searchUser(withUsername username: String, complition: @escaping (_: User?) -> Void) {
        let db = Firestore.firestore()
        db.collection("usernames/\(username)/username").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                complition(nil)
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let id = data["id"] as? String else { return }
                    self?.fetchStrangerProfileInfo(id: id) { user in
                        self?.fetchStrangerProfilePicture(id: id, complition: { image in
                            var finalUser = user
                            finalUser.profilePicture = image
                            complition(finalUser)
                        })
                    }
                }
            }
        }
    }
    
    private func fetchStrangerProfilePicture(id: String, complition: @escaping (_: UIImage) -> Void) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("\(id)/profile_picture.jpg")
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            guard error == nil, data != nil else { return }
            if let image = UIImage(data: data!) {
                complition(image)
            }
        }
    }
    
    func fetchStrangerProfileInfo(id: String, complition: @escaping (_: User) -> Void) {
        let db = Firestore.firestore()
        db.collection("users/\(id)/user_info").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let username = data["username"] as? String else { return }
                    guard let about = data["about"] as? String else { return }
                    let strangerUser = User(id: id, email: "", username: username, about: about)
                    complition(strangerUser)
                }
            }
        }
    }
}
