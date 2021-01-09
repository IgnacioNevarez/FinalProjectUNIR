//
//  Post.swift
//  ProyectoFinal_IgnacioNevarez
//
//  Created by Ignacio Esau Nevarez on 03/01/21.
//

import Foundation

struct Post: Decodable {
    let id: String
    let text: String
    let createdAt: Int
    let imageUrl: String
    let user: User
    
    var fromNow: String?
    var comments: [Comment]?
    var hasLiked: Bool?
}
