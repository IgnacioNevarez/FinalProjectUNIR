//
//  Comment.swift
//  ProyectoFinal_IgnacioNevarez
//
//  Created by Ignacio Esau Nevarez on 03/01/21.
//

import Foundation

struct Comment: Decodable {
    let text: String
    let user: User
    let fromNow: String
}
