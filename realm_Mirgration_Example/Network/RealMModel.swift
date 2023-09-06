//
//  RealMModel.swift
//  realm_Mirgration_Example
//
//  Created by 염성필 on 2023/09/06.
//

import Foundation
import RealmSwift

class UnsplashTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var thumbnailUrl: String
    @Persisted var memoText: String?
    
    convenience init(thumnailUrl: String, memoText: String?) {
        self.init()
        self.thumbnailUrl = thumnailUrl
        self.memoText = memoText
    }
}
