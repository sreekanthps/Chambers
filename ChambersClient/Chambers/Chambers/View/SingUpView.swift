//
//  SingUpView.swift
//  ChambersCognito
//
//  Created by Swetha Sreekanth on 17/7/20.
//  Copyright © 2020 Brewers. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

struct UserModel {
     var userName: String?
     var email: String?
     var password: String?
    
    init(userName: String?, passWord: String?, email: String?) {
        self.userName = userName
        self.email = email
        self.password = passWord
    }
}
class SingUpView: UIView {
    enum Action: DelegateAction {
        case ButtonClick(userModel : UserModel)
        
    }
    weak var delegate: ActionDelegate?
    private let root: UIView = {
      let uiview = UIView()
        uiview.backgroundColor = UIColor.white
      return uiview
    }()
    
    init() {
       super.init(frame: .zero)
       loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
    
    private var userName: UITextField = {
        let user = UITextField(frame: .zero)
        user.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        user.textAlignment = .left
        user.placeholder = "User Name"
        user.textColor = .black
        user.minimumFontSize = 17
        return user
    }()
    private var emailTextField: UITextField = {
        let user = UITextField(frame: .zero)
        user.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        user.textAlignment = .left
        user.placeholder = "Email Address"
        user.textColor = .black
        user.minimumFontSize = 17
        return user
    }()
    
    private var passwordText: UITextField = {
        let user = UITextField(frame: .zero)
        user.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        user.textAlignment = .left
        user.placeholder = "Password"
        user.textColor = .black
        user.minimumFontSize = 17
        return user
    }()
    
    private var userNameLabel : UILabel = {
            let label = UILabel()
            label.text = "User Name"
            return label
    }()
    
    private var passWordLabel : UILabel = {
            let label = UILabel()
            label.text = "Password"
            return label
    }()
    
    private var emailLabel : UILabel = {
            let label = UILabel()
            label.text = "Email Address"
            return label
    }()
    
    private let loginButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = UIColor.red
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    @objc func buttonPressed(_ sender: UIButton) {
        let model  = UserModel(userName: userName.text, passWord: passwordText.text, email: emailTextField.text)
        self.delegate?.actionSender(didReceiveAction: Action.ButtonClick(userModel: model))
        //self.delegate?.actionSender(didReceiveAction: Action.ButtonClick)
    }
    func loadView() {
        root.flex.define { (flex) in
            flex.addItem().marginHorizontal(20).marginVertical(20).define { (flex) in
                flex.addItem(userNameLabel).marginTop(20).marginHorizontal(10)
                flex.addItem(userName).height(40).marginTop(10).marginHorizontal(10)
                
                flex.addItem(emailLabel).marginTop(20)
                flex.addItem(emailTextField).height(40).marginTop(10).marginHorizontal(10)
                flex.addItem(passWordLabel).marginTop(20)
                flex.addItem(passwordText).marginTop(10).height(40).marginHorizontal(10)
                flex.addItem(loginButton).marginTop(40).alignItems(.center).height(40).width(80%)
            }
            
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
}
