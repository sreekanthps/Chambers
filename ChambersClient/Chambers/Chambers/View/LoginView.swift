//
//  LoginView.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 7/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout
import FBSDKCoreKit
class LoginView: UIView {
    fileprivate let root = UIView()
    init() {
        super.init(frame: .zero)
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadView() {
        
        root.flex.justifyContent(.center).padding(10).define { (flex) in
            
        }
        
        addSubview(root)
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        // Layout the flexbox container using PinLayout
        // NOTE: Could be also layouted by setting directly rootFlexContainer.frame
        root.pin.all(pin.safeArea)
        
        // Then let the flexbox container layout itself
        root.flex.layout()
    }
}
