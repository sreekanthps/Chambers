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
class SignUpView: UIView {
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
        //user.placeholder = "User Name"
        user.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.hexColor(Colors.b19)])
        user.textColor = .black
        user.minimumFontSize = 17
        user.layer.cornerRadius = 2
        user.layer.borderWidth = 1
        user.layer.borderColor = UIColor.hexColor(Colors.Borders.b1).cgColor
        return user
    }()
    private var emailTextField: UITextField = {
        let user = UITextField(frame: .zero)
        user.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        user.textAlignment = .left
        //user.placeholder = "Email Address"
        user.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.hexColor(Colors.b19)])
        user.textColor = .black
        user.minimumFontSize = 17
        user.layer.cornerRadius = 5
        user.layer.borderWidth = 1
        user.layer.borderColor = UIColor.hexColor(Colors.Borders.b1).cgColor
        return user
    }()
    
    private var passwordText: UITextField = {
        let user = UITextField(frame: .zero)
        user.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        user.textAlignment = .left
        //user.placeholder = "Password"
        user.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.hexColor(Colors.b19)])
        user.textColor = .black
        user.minimumFontSize = 17
        user.layer.cornerRadius = 5
        user.layer.borderWidth = 1
        user.layer.borderColor = UIColor.hexColor(Colors.Borders.b1).cgColor
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
        button.setTitle("SIGN UP", for: .normal)
        button.backgroundColor = UIColor.hexColor(Colors.Button.secondary)
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
                
                flex.addItem(emailLabel).marginTop(20).marginHorizontal(10)
                flex.addItem(emailTextField).height(40).marginTop(10).marginHorizontal(10)
                flex.addItem(passWordLabel).marginTop(20).marginHorizontal(10)
                flex.addItem(passwordText).marginTop(10).height(40).marginHorizontal(10)
                flex.addItem(loginButton).marginTop(40).height(40).marginHorizontal(10)
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
