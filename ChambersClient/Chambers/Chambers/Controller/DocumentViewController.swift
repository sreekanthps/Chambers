//
//  DocumentViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 13/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//


import UIKit

class DocumentViewController: BaseViewController  {
    var encryptedData: Data? = nil
    var biometric: BioMetircAuthentication = BioMetircAuthentication(viewControler: nil)
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
       biometric.parentVC = self
      biometric = BioMetircAuthentication(viewControler: self)
      self.setupNavigationBar()
      retrieveDocument()
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
        default: return image
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
        if image == nil {
            mainView.updateDocumentDetails(name: nil, fileImage: nil)
        }
        
    }
    private func setupNavigationBar() {
        showNavigationBar(titleColor: UIColor.hexColor(Colors.navBar1), barBackGroundColor: UIColor.hexColor(Colors.navBar1))
           configureBackBarButtonItem(image: "backswe")
    }
    
    override func loadView() {
        let view = DocumentView()
        view.delegate = self
        self.view = view
    }
    func evaluateBiometric() {
        if  biometric.evaluatePolicy() {
            updateDecryptedDetails()
        }
    }
    func updateDecryptedDetails() {
        decryptData()
        if let documentType = store?.getImageforFileType(),let data = encryptedData, ["png","jpeg"].contains(documentType) {
            self.mainView.updateDocumentDetails(name: store?.documentName, fileImage: UIImage(data: data))
        } else {
            self.mainView.updateDocumentDetails(name: store?.documentName, fileImage: UIImage(named: store?.getImageforFileType() ?? "warning"))
        }
    }
    private func decryptData() {
        if let data = encryptedData, let content = crypto.decryptString(data: data) {
          encryptedData = content
        }
    }
    private func retrieveDocument() {
        let login = LoginModel.shared
        if let dbDocument = store, let fileName =  dbDocument.documentName, let id = login.userID{
            let fileName = id + fileName
            let fileUrl = FileURLComponents(fileName: fileName, fileExtension: "sk", directoryName: nil, directoryPath: .documentDirectory)
            do {
                encryptedData = try File.read(from: fileUrl)
            } catch { }
            
        }
    }
}
extension DocumentViewController: ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
        switch action {
        case DocumentView.Action.AuthenticateDocument :
            // Biometric evaluation
            self.evaluateBiometric()
        case DocumentView.Action.DecryptButtonClick :
            // Decrypt the data
            //self.updateDecryptedDetails()
            self.evaluateBiometric()
        case DocumentView.Action.EncryptButtonClick :
          // Encrypt Data
            //self.enc
            self.evaluateBiometric()    
        default: break
        }
        
    }
    
    
}
