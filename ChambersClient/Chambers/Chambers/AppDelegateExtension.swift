//
//  AppDelegateExtension.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 8/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import Foundation
import GoogleSignIn

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let topVC = UtilitiesHelper.getTopViewController() as? LoginViewController {
//            topVC.googleAuthSuccess(userData: user)
//        }

        let newVC = DashboardViewController()
        self.navigationController?.pushViewController(newVC, animated: false)
        if let viewController = UIApplication.shared.topmostViewController() as? LoginViewController {
            viewController.googleAuthSuccess(userData: user)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }

}
