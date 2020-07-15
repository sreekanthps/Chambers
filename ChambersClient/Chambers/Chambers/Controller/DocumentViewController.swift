//
//  DocumentViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 13/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//


import UIKit

class DocumentViewController: BaseViewController  {
    let biometric = BioMetircAuthentication()
    var policy = AuthenticationType.NONE
    let crypto: CryptoHelper = CryptoHelper()
    var store: DocumentStore?
    private var mainView: DocumentView {
        return self.view as! DocumentView
    }

    init(document: DocumentStore) {
        store = document
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
        retrieveDocument()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //let image = canEvaluatePolicy()
        //mainView.updateAuthenticationType(type: policy, authString: image)
        
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
    private func retrieveDocument() {
        var encryptedData: Data? = nil
        let login = LoginModel.shared
        if let dbDocument = store, let fileName =  dbDocument.documentName, let id = login.userID{
            let fileName = id + fileName
            let fileUrl = FileURLComponents(fileName: fileName, fileExtension: "sk", directoryName: nil, directoryPath: .documentDirectory)
            do {
                encryptedData = try File.read(from: fileUrl)
            } catch { }
            if let data = crypto.decryptString(data: encryptedData) , let image = UIImage(data: data){
                print("image found....")
                self.mainView.updateImage(data: image)
                
            }
        }
    }
}
extension DocumentViewController: ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
        
    }
    
    
}
