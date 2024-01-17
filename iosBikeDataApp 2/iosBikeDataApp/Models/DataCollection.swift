//
//  DataCollection.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/23/23.
//

import Foundation

struct DataCollection: Codable, Identifiable, Equatable {
    let id: String
    let Miles: String
    let Time: String
    let createdDate: TimeInterval
    let methodOfTransport: String
}
