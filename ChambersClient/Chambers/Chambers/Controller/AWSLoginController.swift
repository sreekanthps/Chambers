//
//  AWSLoginController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 18/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit

class AWSLoginController: BaseViewController {
    var loginModel: LoginModel? = nil
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
        let view = AWSLoginView()
        view.delegate = self
        self.view = view
    }
    private func validateCredentials(userID: String?, password: String?)  {
        
        
    }
}
extension AWSLoginController : ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
      switch action {
          case AWSLoginView.Action.ButtonClick(let loginType) :
            if loginType == .FACEBOOK {
                
            } else if loginType == .GOOGLE {
                
            }
      case AWSLoginView.Action.NormalLogin(let userID?, let passWord?) :
        self.validateCredentials(userID: userID, password: passWord)
     default: break
      }
    }
}
