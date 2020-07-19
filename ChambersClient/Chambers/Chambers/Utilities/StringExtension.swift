//
//  StringExtension.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 19/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import Foundation
extension String{
    func toDictionary() -> NSDictionary {
        let blankDict : NSDictionary = [:]
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return blankDict
    }
}
