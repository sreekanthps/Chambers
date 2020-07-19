//
//  DocumentStore.swift
//  RealmDatabase
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import Foundation
import RealmSwift

class DocumentStore : Object {
    @objc dynamic var id = 0
    @objc dynamic var documentName: String? = nil
    @objc dynamic var timestamp: Int64 = 0
    @objc dynamic var fileType: String? = nil
    @objc dynamic var datecreation: Date? = nil
    @objc dynamic var userId: String? = nil
    @objc dynamic var dateUpdation: Date? = nil
    @objc dynamic var updateTimestamp: Int64 = 0
    @objc dynamic var storage: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int,documentName: String,timestamp: Int64,
                     fileType: String,datecreation: Date, userId: String?,
                     updatedDate: Date?,updateTime: Int64 = 0, storage: String?) {
        self.init() //Please note this says 'self' and not 'super'
        self.id = id
        self.documentName = documentName
        self.timestamp = timestamp
        self.fileType = fileType
        self.datecreation = datecreation
        self.userId = userId
        self.dateUpdation = updatedDate
        self.updateTimestamp = updateTime
        self.storage = storage
    }
    
    func getImageforFileType() -> String? {
          if let type = fileType {
            switch type {
            case "png","jpeg" : return "photography"
            case "pdf": return "pdf"
            case "docx" : return "microsoft-word"
            case "xlsx" : return "excel"
            case "other" : return "warning"
            default: return "warning"
            }
        }
    return "warning"
    }
    
}
