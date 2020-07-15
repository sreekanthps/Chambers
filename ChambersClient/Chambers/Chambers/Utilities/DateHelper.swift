//
//  DateHelper.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 13/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import Foundation
extension Date {
    var unixTimestamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1_000)
    }
}
