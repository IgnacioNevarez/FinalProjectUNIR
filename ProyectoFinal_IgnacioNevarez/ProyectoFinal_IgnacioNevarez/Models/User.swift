//
//  User.swift
//  ProyectoFinal_IgnacioNevarez
//
//  Created by Ignacio Esau Nevarez on 03/01/21.
//

import Foundation

struct User: Decodable {
    let id: String
    let fullName: String
    var isFollowing: Bool?
    
    var bio, profileImageUrl: String?
    
    var following, followers: [User]?
    
    var posts: [Post]?
    
    var isEditable: Bool?
}
