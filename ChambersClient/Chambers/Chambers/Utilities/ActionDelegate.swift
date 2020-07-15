//
//  ActionDelegate.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 9/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import Foundation

public protocol DelegateAction {}
public protocol ActionDelegate: class {
    func actionSender(didReceiveAction action: DelegateAction)
}
