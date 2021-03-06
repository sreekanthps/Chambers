//
//  AWSLoginController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 18/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit
import Amplify

struct Login {
    var userName: String?
    var passWord: String?
}

class AWSLoginController: BaseViewController {
    var social: LoginType = .NONE
    var loginModel: LoginModel? = nil
    var login: Login? = nil
    private var loginView: AWSLoginView {
        return self.view as! AWSLoginView
    }

    init() {
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = nil
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        //self.singoutUser()
    }
    
    func navigateToDashBoard() {
        DispatchQueue.main.async {
             let newVC = DashboardViewController()
             self.navigationController?.pushViewController(newVC, animated: false)
        }
    }
    
    override func loadView() {
        let view = AWSLoginView()
        view.delegate = self
        self.view = view
    }
    private func validateCredentials(userID: String?, password: String?)  {
        guard let user = userID, let pass = password ,user.count > 0 ,pass.count > 0 else  {
            self.notifyAlert("Login Error", err: "Please Enter User ID/Password")
            return
        }
       self.signIn(username: userID ?? "", password: password ?? "")
    }
    private func signIn(username: String, password: String) {
        if  spinnerView == nil {
            self.spinnerView = self.showSpinner(onView: self.view)
        }
        _ = Amplify.Auth.signIn(username: username, password: password) { result in
            self.removeSpinner(childView: self.spinnerView!)
             self.spinnerView = nil
            switch result {
            case .success(_):
                print("User signin success.......")
                self.fetchAttributes()
                self.navigateToDashBoard()
            case .failure(let error):
                print("Sign in failed \(error)")
                self.removeSpinner(childView: self.spinnerView!)
               
                self.singoutUser()
            }
        }
    }
    private func FacebookAuth(authType: AuthProvider = .facebook) {
           _ = Amplify.Auth.signInWithWebUI(for: authType, presentationAnchor: self.view.window!) { result in
               switch result {
               case .success(_):
                   print("Sign in succeeded")
                   self.fetchAttributes()
                   self.navigateToDashBoard()
               case .failure(let error):
                   print("Sign in failed \(error)")
                   self.singoutUser()
               }
               
           }
       }
       private func singoutUser() {
           _ = Amplify.Auth.signOut() { result in
               switch result {
               case .success:
                   print("Successfully signed out")
                   let authprovider = self.social == .FACEBOOK ? AuthProvider.facebook : AuthProvider.google
                   if self.social == .LOGIN {
                        self.signIn(username: self.login?.userName ?? "", password: self.login?.passWord ?? "")
                   } else {
                        if self.social == .FACEBOOK {
                            self.FacebookAuth(authType: .facebook)
                        } else if self.social == .GOOGLE {
                            self.FacebookAuth(authType: .google)
                        }
                   }
                case .failure(let error):
                   print("Sign out failed with error \(error)")
               }
           }
       }
       func fetchAttributes() {
        _ = Amplify.Auth.fetchUserAttributes() { result in
                   switch result {
                   case .success(let attributes):
                       print("User attributes ***** \(attributes)")
                       self.updateLoginDetails(attributes: attributes)
                   case .failure(let error):
                       print("Fetching user attributes failed with error \(error)")
                   }
           }
       }
    private func updateLoginDetails(attributes: [AuthUserAttribute]?) {
        let currentUser = Amplify.Auth.getCurrentUser()
        print("currentUser......\(currentUser)")
        if let att = attributes {
            if social == .LOGIN {
                let email = att[2].value
                loginModel = LoginModel(userID: currentUser?.userId, email: email)
            } else  {
                if let json = att.filter { $0.key.rawValue == "identities"}.first,
                 let object = json.value.jsonObject() {
                    print("object.....\(object)")
                    loginModel = LoginModel(userID: currentUser?.userId, email: object["userId"] as? String)
                }
               
            }
            
        }
        
    }
    private func navigatetoRegistrationPage() {
        
        let newVC = SignupViewController()
        self.navigationController?.pushViewController(newVC, animated: false)
    }
    
}
extension AWSLoginController : ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
      switch action {
          case AWSLoginView.Action.ButtonClick(let loginType) :
            self.social = loginType
            if loginType == .FACEBOOK {
                self.FacebookAuth(authType: .facebook)
            } else if loginType == .GOOGLE {
                self.FacebookAuth(authType: .google)
            }
      case AWSLoginView.Action.NormalLogin(let userID?, let passWord?) :
        social = .LOGIN
        login = Login(userName: userID, passWord: passWord)
        self.validateCredentials(userID: userID, password: passWord)
      case AWSLoginView.Action.Registration :
        self.navigatetoRegistrationPage()
     default: break
      }
    }
}
