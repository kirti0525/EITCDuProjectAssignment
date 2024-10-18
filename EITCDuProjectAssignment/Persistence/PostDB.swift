//
//  PostDB.swift
//  EITCDuProjectAssignment
//
//  Created by Kirti Kalra on 16/10/24.
//

import Foundation
import RealmSwift

class PostDB: Object {
    @objc dynamic var userId: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var isFavorite: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
