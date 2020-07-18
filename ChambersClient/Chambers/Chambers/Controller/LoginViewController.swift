//
//  LoginViewController.swift
//  Chambers
//  This is first page
//  Created by Swetha Sreekanth on 7/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import AWSAuthCore
import AWSCore

enum AuthType: String {
    case facebook = "Facebook"
    case google = "Google"
    case apple = "apple"
}

class LoginViewController: UIViewController {
    var loginModel: LoginModel? = nil
    private var loginView: LoginView {
        return self.view as! LoginView
    }

    init() {
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var fbButton : FBLoginButton = {
       let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
     fbButton.delegate = self
      GIDSignIn.sharedInstance()?.presentingViewController = self
        self.navigationItem.backBarButtonItem = nil
        // Automatically sign in the user.
       //    GIDSignIn.sharedInstance()?.restorePreviousSignIn()

       // ...
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func navigateToDashBoard() {
        let newVC = DashboardViewController()
        self.navigationController?.pushViewController(newVC, animated: false)
    }
    
    override func loadView() {
        let view = LoginView(button: fbButton)
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
extension LoginViewController: LoginButtonDelegate {
     func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if let _ = result{
                let token = result?.token?.tokenString ?? ""
                let fbAuthRequest = WebIdentityModel(providerId: "289119678902614", roleArn: "arn:aws:iam::873801084462:role/chamberFacebookRole", roleSessionName: "fbacessS3", token: token)
                
                loginModel = LoginModel(loginResponse: result)
                    let mainVC =  DashboardViewController()//LoginViewController()//NewDocumentController()
                    self.navigationController?.pushViewController(mainVC, animated: false)
                }
            }
            
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            print("logout completed")
    }
}


