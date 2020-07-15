//
//  NewDocumentView.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 9/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

enum FileStatus {
    case PLAIN
    case ENCRYPTED
}

class NewDocumentView: UIView {
    var status: FileStatus = .PLAIN
    enum Action: DelegateAction {
        case AddButtonClick
        case EncryptButtonClick
        case DecryptButtonClick
        case UploadButtonClick(isEncryted: Bool = false)
     }
    weak var delegate: ActionDelegate?
    fileprivate let root : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(Colors.backGround)
        return view
    }()
     let preViewimage : UIButton = {
         let image = UIButton()
          image.setImage(UIImage(named: "excel"), for: .normal)
         return image
     }()
   
    private let selectDocView = UIView()
    private let selectLabel : UILabel = {
        let label = UILabel()
        label.text = "Please Select the document "
        label.font = UIFont.getSfProTextBoldStyle(28)
        label.numberOfLines = 2
        return label
    }()
    
    private let selectedView = UIView()
    private let fileName: UILabel = {
        let label = UILabel()
        label.text = "File Name is selected"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.hexColor(Colors.bc3)
        label.numberOfLines = 2
        return label
    }()
  
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "filesandfolders"), for: .normal)
        button.addTarget(self, action: #selector(addDocument(_:)), for: .touchUpInside)
        return button
    }()
    
    let cryptButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "binary"), for: .normal)
        button.addTarget(self, action: #selector(cryptButton(_:)), for: .touchUpInside)
        return button
    }()
    let uopload : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "upload"), for: .normal)
        button.addTarget(self, action: #selector(uploadButtonSelected(_:)), for: .touchUpInside)
        return button
    }()
    
    
    init() {
        super.init(frame: .zero)
        configure()
        loadView()
     }
    
    private func configure() {
        flexVisibility(visible: true)
    }
    @objc func addDocument(_ sender: UIButton) {
        self.delegate?.actionSender(didReceiveAction: Action.AddButtonClick)
    }
    @objc func uploadButtonSelected(_ sender: UIButton) {
        self.delegate?.actionSender(didReceiveAction: Action.UploadButtonClick(isEncryted: status == .PLAIN ? false : true))
    }
    
    @objc func cryptButton(_ sender: UIButton) {
        self.delegate?.actionSender(didReceiveAction: status == .PLAIN ? Action.EncryptButtonClick : Action.DecryptButtonClick)
        if status == .PLAIN {
            status = .ENCRYPTED
        } else {
            status = .PLAIN
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadView() {
        removeAllSubviewsAndRemoveFromSuperview()
        root.flex.padding(10).alignItems(.center).define { (flex) in
            flex.addItem(selectDocView).justifyContent(.center).alignItems(.center).width(100%).height(100%).define { (flex) in
                flex.addItem(selectLabel).marginTop(-100).marginHorizontal(15)
                flex.addItem(addButton).size(100).marginTop(40).marginRight(0)
                
            }
            flex.addItem(selectedView).alignItems(.center).width(100%).height(100%).define { (flex) in
                flex.addItem(fileName).marginTop(70)
                flex.addItem(preViewimage).marginTop(40).size(270)
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
        selectLabel.pin.left(0)
        uopload.pin.right(0)
        // Then let the flexbox container layout itself
        root.flex.layout()
    }
    func updateDecryptButton(fileModel: FileModel?)  {
        flexVisibility(visible: false)
        var image = UIImage(named: "warning")
        if let contentType = fileModel?.contentType, [ContentType.PNGIMAGE,ContentType.JPEGIMAGE].contains(contentType) {
           image = fileModel?.fileImage
        } else {
            image = UIImage(named: fileModel?.getImageAssetType() ?? "warning")
        }
        self.preViewimage.setImage(image, for: .normal)
        fileName.text = fileModel?.fileName
        self.layoutSubviews()
    }
    
    private func flexVisibility(visible: Bool = true) {
        selectDocView.isHidden = !visible
        selectDocView.flex.isIncludedInLayout = visible
        selectedView.isHidden = visible
        selectedView.flex.isIncludedInLayout = !visible
       
    }
    func updateEncryptedView() {
        self.cryptButton.setImage(UIImage(named: "binaryencrypt"), for: .normal)
        self.preViewimage.setImage(UIImage(named: "encrypted"), for: .normal)
        
        
    }
    func updateDecryptedView(image: UIImage?) {
        self.cryptButton.setImage(UIImage(named: "binary"), for: .normal)
        //self.cryptButton.setImage(image: UIImage(named: "binary"), for: .normal)
        self.preViewimage.setImage(image, for: .normal)
            
    }
}
