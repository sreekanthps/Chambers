//
//  AppDelegateExtension.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 8/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import Foundation
import GoogleSignIn

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
        if user != nil, let _ = user.userID {
            let _  = LoginModel(loginResponse: user)
            let newVC = DashboardViewController()
            self.navigationController?.pushViewController(newVC, animated: false)
        } else {
            // Login did not happen
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }

}
