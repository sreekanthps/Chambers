//
//  ViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 7/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
               loginButton.center = view.center
         view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }


}

extension ViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
       
        print("Login completed....\(result?.token)")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout completed")
    }
    
    
}
