//
//  LoginViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 7/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    private var loginView: LoginView {
        return self.view as! LoginView
    }

    init() {
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
      super.viewDidLoad()
      GIDSignIn.sharedInstance()?.presentingViewController = self

      // Automatically sign in the user.
      //    GIDSignIn.sharedInstance()?.restorePreviousSignIn()

      // ...
    }
    
    override func loadView() {
        self.view = LoginView()
    }
}
