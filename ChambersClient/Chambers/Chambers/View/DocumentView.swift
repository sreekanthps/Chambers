
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
       case EncryptButtonClick
       case DecryptButtonClick
       case AuthenticateDocument
    }
    weak var delegate: ActionDelegate?
    var status: FileStatus = .PLAIN
    
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
    let cryptButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "binary"), for: .normal)
        button.addTarget(self, action: #selector(cryptButton(_:)), for: .touchUpInside)
        return button
    }()
    private let fileName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.hexColor(Colors.bc3)
        label.numberOfLines = 2
        return label
    }()
    
    @objc func cryptButton(_ sender: UIButton) {
        if status == .ENCRYPTED {
            cryptButton.setImage(UIImage(named: "binary"), for: .normal)
            status = .PLAIN
            delegate?.actionSender(didReceiveAction: Action.DecryptButtonClick)
        } else {
            status = .ENCRYPTED
            cryptButton.setImage(UIImage(named: "binaryencrypt"), for: .normal)
            delegate?.actionSender(didReceiveAction: Action.EncryptButtonClick)
        }
    }
    private let dataView = UIView()
    init() {
        super.init(frame: .zero)
        configure()
        loadView()
     }
    
    private func configure() {
       
    }
    @objc func authenticateDocument(_ sender: UIButton) {
        delegate?.actionSender(didReceiveAction: Action.AuthenticateDocument)
    }
    
    func updateAuthenticationType(type: AuthenticationType, authString: String?) {
        if let img = authString {
            plusButton.setImage(UIImage(named: img), for: .normal)
        } else {
            updateViewStatus(status: false)
        }
    }
    
    func updateDocumentDetails(name: String?, fileImage: UIImage?) {
        if let img = fileImage, let fname = name {
            // Unencrypted Files
            fileName.text = fname
            image.image = img
        } else {
            fileName.isHidden = true
            image.image = UIImage(named: "encrypted")
        }
    }
    func updateAuthentceViewDetails(name: String?, fileImage: UIImage?) {
         status = .PLAIN
         fileName.text = name
         image.image = fileImage
         cryptButton.setImage(UIImage(named: "binary"), for: .normal)
    }
    
    private func updateViewStatus(status: Bool = false) {
        image.isHidden = status
        image.flex.isIncludedInLayout = !status
        authView.isHidden = !status
        authView.flex.isIncludedInLayout = status
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func updateImage(data : UIImage?) {
        image.image = data
    }
    
    func loadView() {
        
        root.flex.padding(10).alignItems(.center).define { (flex) in
            flex.addItem(authView).justifyContent(.center).alignItems(.center).width(100%).height(100%).define { (flex) in
                flex.addItem(label).marginTop(-40).marginHorizontal(30)
                flex.addItem(plusButton).size(100).marginTop(30)
            }
            flex.addItem(dataView).alignItems(.center).width(100%).height(100%).define { (flex) in
                flex.addItem(fileName).marginTop(70)
                flex.addItem(image).marginTop(40).size(270).alignSelf(.center)
                flex.addItem(cryptButton).size(100).marginTop(30)
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
