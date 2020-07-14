//
//  DocumentViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 13/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//


import UIKit

class DocumentViewController: BaseViewController  {
    let biometric = BioMetircAuthentication()
    var policy = AuthenticationType.NONE
    private var mainView: DocumentView {
        return self.view as! DocumentView
    }

    init() {
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
      super.viewDidLoad()
      self.setupNavigationBar()
      
    }
    
    private func canEvaluatePolicy() -> String? {
         policy = biometric.canEvaluatePolicy()
        var image: String? = nil
        switch policy {
            case AuthenticationType.FACE:
             image = "identity"
        case AuthenticationType.FINGURE:
            image = "biometric"
        case AuthenticationType.KEYPAD :
            image = "keypad"
        case AuthenticationType.NONE :
            print("No authentication available")
            // No authentication available
        default: print("No authentication available")
        }
        return image
    }
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = canEvaluatePolicy()
        mainView.updateAuthenticationType(type: policy, authString: image)
    }
    private func setupNavigationBar() {
        let navmodal = NavigationModel(title: "New Document", lbTitle: ImageName.back, rbTitle: nil, barTintColor: UIColor.hexColor(Colors.Button.secondary), titleColor: UIColor.black, lbTintColor: UIColor.hexColor(Colors.bc5), rbTintColor: UIColor.hexColor(Colors.bc5), rbWidth: 40)
        
         //self.setupNavigationBar(navModel: navmodal)
    }
    
    override func loadView() {
        let view = DocumentView()
        view.delegate = self
        self.view = view
    }
    func evaluateBiometric() {
        
    }
}
extension DocumentViewController: ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
        
    }
    
    
}
