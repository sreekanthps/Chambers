//
//  SignUpConfirmView.swift
//  ChambersCognito
//
//  Created by Swetha Sreekanth on 17/7/20.
//  Copyright © 2020 Brewers. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

class SignUpConfirmView: UIView {
    enum Action: DelegateAction {
        case ButtonClick(confirmCode : String?)
        
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
    private var userNameLabel : UILabel = {
               let label = UILabel()
               label.text = "Confirmation Code"
               label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
               return label
       }()
    
    private var userName: UITextField = {
        let user = UITextField(frame: .zero)
        user.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        user.textAlignment = .left
        //user.placeholder = "Cofirmation Code"
        user.attributedPlaceholder = NSAttributedString(string: "Cofirmation Code", attributes: [NSAttributedString.Key.foregroundColor : UIColor.hexColor(Colors.b19)])
        user.textColor = .black
        user.minimumFontSize = 17
        user.layer.cornerRadius = 5
        user.layer.borderWidth = 1
        user.layer.borderColor = UIColor.hexColor(Colors.Borders.b1).cgColor
        return user
       
    }()
  
    
    private let loginButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("CONFIRM", for: .normal)
        button.backgroundColor = UIColor.red
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    @objc func buttonPressed(_ sender: UIButton) {
        self.delegate?.actionSender(didReceiveAction: Action.ButtonClick(confirmCode: userName.text))
        //self.delegate?.actionSender(didReceiveAction: Action.ButtonClick)
    }
    func loadView() {
        root.flex.define { (flex) in
            flex.addItem().marginHorizontal(30).marginVertical(20).define { (flex) in
                flex.addItem(userNameLabel).marginTop(20)
                flex.addItem(userName).height(40).marginTop(10)
                flex.addItem(loginButton).marginTop(40).height(40)
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
