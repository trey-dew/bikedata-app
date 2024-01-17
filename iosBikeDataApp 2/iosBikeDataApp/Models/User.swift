//
//  User.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/4/23.
//

import Foundation

struct User:  Codable {
    let  id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
