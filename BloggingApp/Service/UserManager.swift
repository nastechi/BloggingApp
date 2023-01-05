//
//  UserManager.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit
import FirebaseAuth

protocol UserManagerDelegate {
    func didUpdateUser()
    func didLogoutUser()
}

protocol ProfileManagerDelegate {
    func didUpdateProfilePicture()
    func didUpdateUsername()
    func didUpdateAbout()
}

final class UserManager {
    
    var user: User?
    var delegate: UserManagerDelegate?
    var profileDelegate: ProfileManagerDelegate?
    
    func fetchUser() {
        let auth = Auth.auth()
        if let email = auth.currentUser?.email, let id = auth.currentUser?.uid {
            user = User(id: id, email: email)
        } else if user != nil {
            user = nil
            delegate?.didLogoutUser()
        }
        delegate?.didUpdateUser()
    }
    
    func registerUser(withEmail email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            self?.fetchUser()
        }
        
    }
    
    func logInUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            strongSelf.fetchUser()
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
        // load img to firebase
        self.user?.profilePicture = picture
        profileDelegate?.didUpdateProfilePicture()
    }
    
    func changeUsername(to username: String) {
        
    }
    
    func changeAbout(to about: String) {
        
    }
}
