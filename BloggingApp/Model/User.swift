//
//  User.swift
//  BloggingApp
//
//  Created by Анастасия on 05.01.2023.
//

import UIKit

struct User {
    var id: String
    var email: String
    var profilePicture: UIImage? = UIImage(systemName: "person")
    var username: String? = "username"
    var about: String? = "about me"
}
