//
//  StringExtension.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 19/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
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
    
    func jsonObject() -> [String:AnyObject]? {
        do{
            if let json = self.data(using: String.Encoding.utf8),
            let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [Dictionary<String,AnyObject>] {
                
                print("jsonData.....\(jsonData)")
                return jsonData[0]
            }
        }catch {
            print(error.localizedDescription)

        }
        return nil
    }
    
}
