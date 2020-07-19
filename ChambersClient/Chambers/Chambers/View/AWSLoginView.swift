//
//  AWSLoginView.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 18/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit

enum LoginType {
    case LOGIN
    case GOOGLE
    case FACEBOOK
    case NONE
}
class AWSLoginView: UIView {
    enum Action: DelegateAction {
        case ButtonClick(loginType: LoginType)
        case NormalLogin(userID: String?, password: String?)
        case Registration
    }
    var loginType: LoginType = .NONE
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
        //user.placeholder = "User ID"
        user.attributedPlaceholder = NSAttributedString(string: "User ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.hexColor(Colors.b19)])
         user.textColor = .black
        user.textColor = UIColor.hexColor(Colors.b19)//bc5
        user.minimumFontSize = 17
        return user
    }()
    private var lineVIew: UIView = {
       let uivew = UIView()
        uivew.backgroundColor = .orange
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
        user.textColor = .black
        user.placeholder = "PIN"
        user.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.hexColor(Colors.b19)])
        user.textColor = UIColor.hexColor(Colors.b19)//bc5
        user.minimumFontSize = 17
        return user
    }()
    
    
    private let fbloginButton : UIButton = {
        let button = UIButton(frame: .zero)
        //button.setTitle("FaceBook Login", for: .normal)
        button.setBackgroundImage(UIImage(named: "facebook"), for: .normal)
        //button.backgroundColor = UIColor.hexColor(Colors.Button.secondary)
        //button.setTitleColor(.white, for: .normal)
        //button.titleLabel?.font = UIFont.getDefaultFontBoldStyle(18)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(fbbuttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    private let googleloginButton : UIButton = {
        let button = UIButton(frame: .zero)
        //button.setTitle("Google Login", for: .normal)
        button.setBackgroundImage(UIImage(named: "google1"), for: .normal)
        //button.backgroundColor = UIColor.hexColor(Colors.Button.secondary)
        //button.setTitleColor(.white, for: .normal)
        //button.titleLabel?.font = UIFont.getDefaultFontBoldStyle(18)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(googlebuttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    private let register: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("New User ? Register Here", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(registration(_:)), for: .touchUpInside)
        return button
    }()
    
    init() {
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
            flex.addItem(register).marginLeft(46).height(30).width(172).marginTop(12)
            flex.addItem(loginButton).height(40).marginHorizontal(46).marginTop(40)
            flex.addItem(fbloginButton).height(40).marginHorizontal(46).marginTop(40)
            flex.addItem(googleloginButton).height(40).marginHorizontal(46).marginTop(20)
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
        self.delegate?.actionSender(didReceiveAction: Action.NormalLogin(userID: userIdText.text, password: passWord.text))
    }
    @objc func fbbuttonPressed(_ sender: UIButton) {
        print("facebook button pressed")
        self.delegate?.actionSender(didReceiveAction: Action.ButtonClick(loginType: .FACEBOOK))
    }
    @objc func googlebuttonPressed(_ sender: UIButton) {
        self.delegate?.actionSender(didReceiveAction: Action.ButtonClick(loginType: .GOOGLE))
       
    }
    @objc func registration(_ sender: UIButton) {
        self.delegate?.actionSender(didReceiveAction: Action.Registration)
       
    }
    
}
