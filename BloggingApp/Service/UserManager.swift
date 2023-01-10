//
//  UserManager.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

protocol UserManagerDelegate {
    func didUpdateUser()
    func didLogoutUser()
}

protocol ProfileManagerDelegate {
    func didUpdateUser()
    func didFailWithError(error: Error)
}

final class UserManager {
    
    var user: User?
    var delegate: UserManagerDelegate?
    var profileDelegate: ProfileManagerDelegate?
    
    func fetchUser() {
        let auth = Auth.auth()
        if let email = auth.currentUser?.email, let id = auth.currentUser?.uid {
            user = User(id: id, email: email)
            fetchProfileInfo()
            fetchProfilePicture { [weak self] in
                self?.delegate?.didUpdateUser()
                self?.profileDelegate?.didUpdateUser()
            }
        } else if user != nil {
            user = nil
            delegate?.didLogoutUser()
        } else {
            delegate?.didUpdateUser()
        }
    }
    
    private func fetchProfilePicture(complition: @escaping () -> Void) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("\(user!.id)/profile_picture.jpg")
        fileRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard error == nil, data != nil else { return }
            let image = UIImage(data: data!)
            self?.user?.profilePicture = image
            complition()
        }
    }
    
    private func fetchProfileInfo() {
        let db = Firestore.firestore()
        db.collection("users/\(user!.id)/user_info").getDocuments() { [weak self] (querySnapshot, err) in
            if err != nil {
                print("Error getting documents: \(err!)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let username = data["username"] as? String else { return }
                    guard let about = data["about"] as? String else { return }
                    self?.user?.username = username
                    self?.user?.about = about
                }
            }
        }
    }
    
    func registerUser(withEmail email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                self?.profileDelegate?.didFailWithError(error: error!)
                print(error!.localizedDescription)
                return
            }
            self?.setDefaultUserInfo()
        }
    }
    
    private func setDefaultUserInfo() {
        let db = Firestore.firestore()
        guard let username = Auth.auth().currentUser?.uid else { return }
        db.collection("users/\(String(describing: username))/user_info").document("user_info").setData([
            "username": username,
            "about": "Hello! I'm using the BloggingApp."
        ]) { [weak self] err in
            if err != nil {
                print("Error writing document: \(err!)")
            } else {
                self?.setDefaultProfilePicture(forUsername: username)
            }
        }
        db.collection("usernames/\(username)/username").document(username).setData([
            "id": username
        ])
    }
    
    private func setDefaultProfilePicture(forUsername username: String) {
        guard let picture = UIImage(systemName: "person") else { return }
        guard let data = picture.jpegData(compressionQuality: 0.7) else { return }
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("\(username)/profile_picture.jpg")
        fileRef.putData(data) { [weak self] _, error in
            guard error == nil else { return }
            
            self?.fetchUser()
            self?.profileDelegate?.didUpdateUser()
        }
    }
    
    func logInUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            self?.fetchUser()
        }
    }
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        fetchUser()
    }
    
    func changeProfilePicture(to picture: UIImage) {
        
        guard let data = picture.jpegData(compressionQuality: 0.7) else { return }
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("\(user!.id)/profile_picture.jpg")
        let _ = fileRef.putData(data) { [weak self] metadata, error in
            guard error == nil else { return }
            
            self?.user?.profilePicture = picture
            self?.profileDelegate?.didUpdateUser()
        }
    }
    
    func changeUserInfo(to username: String, about: String) {
        let db = Firestore.firestore()
        
        if username != user?.username {
            updateUsernamesDB(toUsername: username)
        }
        
        let ref = db.collection("users/\(user!.id)/user_info").document("user_info")
        ref.updateData([
            "username": username,
            "about": about
        ]) { [weak self] err in
            if err != nil {
                print("Error updating document: \(err!)")
            } else {
                self?.user?.username = username
                self?.user?.about = about
                self?.profileDelegate?.didUpdateUser()
            }
        }
    }
    
    private func updateUsernamesDB(toUsername username: String) {
        let db = Firestore.firestore()
        
        db.collection("usernames").document(user!.username!).delete()
        db.collection("usernames/\(username)/username").document(username).setData([
            "id": user!.id
        ])
    }
}
