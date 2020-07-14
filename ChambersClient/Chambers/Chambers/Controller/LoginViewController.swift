//
//  LoginViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 7/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit
import GoogleSignIn

enum AuthType: String {
    case facebook = "Facebook"
    case google = "Google"
    case apple = "apple"
}

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
        //self.navigationController?.navigationBar.barTintColor = .white
      // Automatically sign in the user.
      //    GIDSignIn.sharedInstance()?.restorePreviousSignIn()

      // ...
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    func navigateToDashBoard() {
        //let newVC = NewDocumentController()
        let newVC = DashboardViewController()
        self.navigationController?.pushViewController(newVC, animated: false)
    }
    
    override func loadView() {
        let view = LoginView()
        view.delegate = self
        self.view = view
    }
    func googleAuthSuccess(userData: GIDGoogleUser?) {
        guard let user = userData, let auth = user.authentication,
            let token = auth.accessToken,  token.count > 0 else{
                return
        }
        print("Gogole token...\(token)")
        navigateToDashBoard()
        
    }
}

extension LoginViewController: ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
        switch action {
            case LoginView.Action.ButtonClick :
                print("Loginbutton pressed")
                self.navigateToDashBoard()
            case LoginView.Action.FacebookButtonClick : print("facebook Button pressed")
            case LoginView.Action.GoogleButtonClick: print("Google button pressed")
            default: break
        }
      }
}


