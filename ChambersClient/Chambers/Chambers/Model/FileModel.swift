//
//  FileModel.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 14/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import Foundation

struct FileModel {
    var fileName: String?
    var fileExtension: String?
    var fileData: Data?
    var fileImage: UIImage?
    var encryptedData: Data?
    var contentType: ContentType? = .OTHER
    var fileUploadNmae: String? = nil
    
    func getImageAssetType() -> String? {
        switch contentType {
        case .EXCEL : return "excel"
        case .PDF : return "pdf"
        case .PNGIMAGE,.JPEGIMAGE : return nil
        case .WORD: return "microsoft-word"
        case .OTHER: return "warning"
        default:  return "warning"
        }
    }
}
