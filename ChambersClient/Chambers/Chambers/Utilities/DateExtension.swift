//
//  DateExtension.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 15/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import Foundation
public struct DateFormat {
    public static let ddMMMyyyy = "dd MMM yyyy"
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}

