//
//  PostsModel.swift
//  EITCDuProjectAssignment
//
//  Created by Kirti Kalra on 16/10/24.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

extension Post {
    init(realmObject: PostDB) {
        self.id = realmObject.id
        self.title = realmObject.title
        self.body = realmObject.body
        self.userId = realmObject.userId
    }
}
