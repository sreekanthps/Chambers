//
//  DocumentStore.swift
//  RealmDatabase
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import Foundation
import RealmSwift

class DocumentStore : Object {
    @objc dynamic var id = 0
    @objc dynamic var documentName: String? = nil
    @objc dynamic var timestamp: Int64 = 0
    @objc dynamic var fileType: String? = nil
    @objc dynamic var datecreation: Date? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int,documentName: String,timestamp: Int64,
                     fileType: String,datecreation: Date) {
        self.init() //Please note this says 'self' and not 'super'
        self.id = id
        self.documentName = documentName
        self.timestamp = timestamp
        self.fileType = fileType
        self.datecreation = datecreation
    }
    
}
