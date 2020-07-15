//
//  CryptoHelper.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 10/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import Foundation
import CryptoKit
import CryptoSwift


class CryptoHelper {
    let plaintext: String = "Converting my plain text to cypher text"
    let additionnal: String = "additional string"
    var keyString: Data? = nil
    let salt: Data = "abcdefghijlkmnop".data(using: String.Encoding.utf8)!
    let addData = "additional string".data(using: String.Encoding.utf8)!
    let ivDat = "abcdefghijklmnop".data(using:String.Encoding.utf8)!
    init() {
        keyString = try! CC.KeyDerivation.PBKDF2("sreekanth", salt: salt, prf: .sha256, rounds: 100000)
    }
    
    func pbkdf2(hash: CCPBKDFAlgorithm, password: String, salt: String, keyByteCount: Int, rounds: Int) -> Data? {
        guard let passwordData = password.data(using: .utf8), let saltData = salt.data(using: .utf8) else { return nil }
        
        var derivedKeyData = Data(repeating: 0, count: keyByteCount)
        let derivedCount = derivedKeyData.count

        let derivationStatus = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
            saltData.withUnsafeBytes { saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password,
                    passwordData.count,
                    saltBytes,
                    saltData.count,
                    hash,
                    UInt32(rounds),
                    derivedKeyBytes,
                    derivedCount)
            }
        }

        return derivationStatus == kCCSuccess ? derivedKeyData : nil
    }

    func encryptData(plainData: Data?) -> Data? {
            var encryptData: Data? = nil
            if let key = keyString, let data =  plainData {
                encryptData = try! CC.cryptAuth(.encrypt, blockMode: .gcm, algorithm: .aes, data: data, aData: addData, key: key, iv: ivDat, tagLength: 16)
            }
            return encryptData
        }
    
    func decryptString(data: Data?) -> Data? {
            var decryptString: Data? = nil
            if let key = keyString, let encryptedData = data {
                decryptString = try! CC.cryptAuth(.decrypt, blockMode: .gcm, algorithm: .aes, data: encryptedData, aData: addData, key: key, iv: ivDat, tagLength: 16)
            }
            return decryptString
    }
        
}
