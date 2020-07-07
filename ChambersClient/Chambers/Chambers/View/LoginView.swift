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
import FBSDKLoginKit

class LoginView: UIView {
    fileprivate let root = UIView()
    private let fbLogin : FBLoginButton = {
         let loginButton = FBLoginButton()
         //loginButton.delegate = self
         loginButton.permissions = ["public_profile", "email"]
         return loginButton
    }()
    
    init() {
        super.init(frame: .zero)
        loadView()
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadView() {
        root.backgroundColor = .white
        root.flex.justifyContent(.center).padding(10).alignItems(.center).define { (flex) in
            flex.addItem(fbLogin).height(40).width(60%)
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

extension LoginView: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
       print("Login completed....\(result?.token)")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout completed")
    }
}
