//
//  AppDelegate.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 7/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import Amplify
import AmplifyPlugins
import RealmSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "828971646330-eno5kior4au558sdh0ssecev4rja905e.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        setupRootViewController(launchOptions: launchOptions)
        do {
            Amplify.Logging.logLevel = .verbose
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

      return GIDSignIn.sharedInstance().handle(url)
    }
    
    // Method to invoke Assign First view controller dynamically
    func setupRootViewController(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            let mainVC =  SplashViewController()
            navigationController = UINavigationController(rootViewController: mainVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

}

