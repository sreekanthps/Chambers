//
//  LoginView.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 7/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout
import FBSDKCoreKit
import FBSDKLoginKit

import GoogleSignIn

class LoginView: UIView {
    
    enum Action: DelegateAction {
        case ButtonClick
        case GoogleButtonClick
        case FacebookButtonClick
    }
    var fbButton: FBLoginButton
    var viewController: LoginViewController?
    weak var delegate: ActionDelegate?
    private let root: UIView = {
      let uiview = UIView()
        uiview.backgroundColor = UIColor.hexColor(Colors.backGround)
      return uiview
    }()
    
    private let loginView: UIView = {
        let uiView = UIView(frame: .zero)
        uiView.backgroundColor = UIColor.white
        uiView.layer.cornerRadius = 10
        return uiView
    }()
    
    private var userIdText: UITextField = {
        let user = UITextField(frame: .zero)
        user.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        user.textAlignment = .left
        user.placeholder = "User ID"
        user.textColor = UIColor.hexColor(Colors.bc5)
        user.minimumFontSize = 17
        return user
    }()
    private var lineVIew: UIView = {
       let uivew = UIView()
        uivew.backgroundColor = .black
        return uivew
        
    }()
    private let loginButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = UIColor.hexColor(Colors.Button.secondary)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.getDefaultFontBoldStyle(18)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    private var passWord: UITextField = {
        let user = UITextField(frame: .zero)
        user.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        user.textAlignment = .left
        user.isSecureTextEntry = true
        user.placeholder = "PIN"
        user.minimumFontSize = 17
        return user
    }()
    
    
     private let googleLogin : GIDSignInButton = {
         let loginButton = GIDSignInButton()
        
         return loginButton
    }()
    
    init(button: FBLoginButton) {
         self.fbButton = button
        super.init(frame: .zero)
        loadView()
     }
    
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    func loadView() {
        root.flex.define { (flex) in
            flex.addItem(loginView).marginTop(150).minHeight(90).marginHorizontal(30).define { (flex) in
                flex.addItem(userIdText).marginHorizontal(16).height(44)
                flex.addItem(lineVIew).marginLeft(16).height(1).marginRight(0)
                flex.addItem(passWord).marginHorizontal(16).height(44)
            }
            flex.addItem(loginButton).height(40).marginHorizontal(30).marginTop(40)
            flex.addItem(fbButton).height(50).marginTop(40).marginHorizontal(40)
        }
        addSubview(root)
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        // Layout the flexbox container using PinLayout
        // NOTE: Could be also layouted by setting directly rootFlexContainer.frame
        root.pin.all(pin.safeArea)
        
        // Then let the flexbox container layout itself
        root.flex.layout()
    }
    @objc func buttonPressed(_ sender: UIButton) {
        self.delegate?.actionSender(didReceiveAction: Action.ButtonClick)
    }
}
//extension LoginView: LoginButtonDelegate {
//
//}
extension LoginView: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("Login completed....\(result?.token)")

    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout completed")
    }
}
