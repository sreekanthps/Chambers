//
//  AppDelegate.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 7/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import PinLayout

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions)
        setupRootViewController(launchOptions: launchOptions)
        return true
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }
    // Method to invoke Assign First view controller dynamically
    
    func setUpMainViewController(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
            let appDelegate = UIApplication.shared.delegate
            let rootVC = LoginViewController()
            if let window = appDelegate!.window {
                let navigationController = UINavigationController(rootViewController: rootVC)
                rootVC.navigationController?.isNavigationBarHidden = true
                navigationController.isNavigationBarHidden = true
                //The line which not related to DSAA-30601 is commented, tested with Adhoc build from same test case, it works as expected
                window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
            }
        }
    
    func setupRootViewController(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let mainVC = LoginViewController()
            navigationController = UINavigationController(rootViewController: mainVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

}

