
//
//  DocumentViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 13/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

class DocumentView: UIView {
    enum Action: DelegateAction {
          case ButtonClick
    }
    weak var delegate: ActionDelegate?
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "biometric"), for: .normal)
        button.addTarget(self, action: #selector(authenticateDocument(_:)), for: .touchUpInside)
        return button
    }()
    let root : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(Colors.backGround)
        return view
    }()
    let authView  = UIView()
    
    private let image = UIImageView()
    let label: UILabel = {
        let label = UILabel()
        label.text = "Please Authenticate with Device Authorization"
        label.font = UIFont.getSfProTextBoldStyle(28)
        label.numberOfLines = 2
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configure()
        loadView()
     }
    
    private func configure() {
        //image.isHidden = true
        //image.flex.isIncludedInLayout = false
    }
    @objc func authenticateDocument(_ sender: UIButton) {
        delegate?.actionSender(didReceiveAction: Action.ButtonClick)
    }
    
    func updateAuthenticationType(type: AuthenticationType, authString: String?) {
        if let img = authString {
            plusButton.setImage(UIImage(named: img), for: .normal)
        } else {
            image.isHidden = false
            image.flex.isIncludedInLayout = true
            authView.isHidden = true
            authView.flex.isIncludedInLayout = false
        }
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func updateImage(data : UIImage?) {
        image.image = data
    }
    
    func loadView() {
        
        root.flex.padding(10).alignItems(.center).define { (flex) in
//            flex.addItem(authView).justifyContent(.center).alignItems(.center).width(100%).height(100%).define { (flex) in
//                flex.addItem(label).marginTop(-40).marginHorizontal(30)
//                flex.addItem(plusButton).size(100).marginTop(30)
//            }
            flex.addItem(image).marginTop(40).size(270).alignSelf(.center)
            
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
