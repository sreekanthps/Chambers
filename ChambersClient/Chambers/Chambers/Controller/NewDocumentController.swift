//
//  NewDocumentController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 9/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit
import Photos
import CryptoSwift
import CommonCrypto
import PhotosUI


class NewDocumentController: BaseViewController {
    
    let crypto: CryptoHelper = CryptoHelper()
    
    private var mainView: NewDocumentView {
        return self.view as! NewDocumentView
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
    private func setupNavigationBar() {
        let navmodal = NavigationModel(title: "New Document", lbTitle: ImageName.back, rbTitle: nil, barTintColor: UIColor.hexColor(Colors.Button.secondary), titleColor: UIColor.black, lbTintColor: UIColor.hexColor(Colors.bc5), rbTintColor: UIColor.hexColor(Colors.bc5), rbWidth: 40)
        //setStatusBarBackgroundColor(color: .clear)
        //preferredStatusBarStyleDark()
         //self.showDropDownShadowForNavigationBar(UIColor(white: 0.0, alpha: 0.1))
        self.setupNavigationBar(navModel: navmodal)
    }
    
    override func loadView() {
        let view = NewDocumentView()
        view.delegate = self
        self.view = view
    }
    
    func showPhotoMenu() {
        let actions = ["Choose Existing",
                       "Take Photo",
                       "CANCEL"]
        UtilitiesHelper.presentActionSheet(nil, message: nil, actions: actions, controller: self) { (alertVC, selectedAction) in
            alertVC.dismiss(animated: true, completion: nil)
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if selectedAction == "Choose Existing" {
                               self.authorisationStatus(type: .photoLibrary)
                           } else if selectedAction == "Take Photo" {
                               self.authorisationStatus(type: .camera)
                           }
                       }
        }
    }
    
    func authorisationStatus(type: UIImagePickerController.SourceType) {
        if type == .camera {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                openCamera()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if granted {
                        self.openCamera()
                    }
                }
            case .denied, .restricted:
                print("permission denied")
//                CommonUtilities.showSettingAlert(parentVC: self,
//                                                 title: getLocalizedString(for: "digibank_Alert"),
//                                                 msg: "photo_camera_error_msg_1".localized)
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                self.openPhotoLibrary()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (authStatus) in
                    if authStatus == .authorized {
                        self.openPhotoLibrary()
                    }
                }
            case .denied, .restricted:
                print("Permission denied.....")
//                CommonUtilities.showSettingAlert(parentVC: self,
//                                                 title: getLocalizedString(for: "digibank_Alert"),
//                                                 msg: "photo_gallery_error_msg_1".localized)
            }
        }
    }

    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }
        }
    }

    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }
}

extension NewDocumentController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                 picker.dismiss(animated: false, completion: { () -> Void in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.mainView.updateDecryptButton(imageUrl: selectedImage)
                    }
                    
                  })
        }
    }
}

extension NewDocumentController: ActionDelegate {
    public func actionSender(didReceiveAction action: DelegateAction) {
        switch action {
        case NewDocumentView.Action.ButtonClick :
             self.showPhotoMenu()
        case NewDocumentView.Action.PorcessImage(let image) :
            print("process image")
            if let data: Data = image?.pngData() {
                print("Image converted to Data...")
                if let encrpytedData = crypto.encryptData(plainData: data) {
                    let fileUrl = FileURLComponents(fileName: "testingImageName", fileExtension: "sk", directoryName: nil, directoryPath: .documentDirectory)
                    do {
                        _ = try File.write(encrpytedData, to: fileUrl)
                    } catch {
                       
                    }
                }
                
            }
        case NewDocumentView.Action.DecryptImage :
            print("Load the file for document folder and display back")
            var encryptedData: Data? = nil
            let fileUrl = FileURLComponents(fileName: "testingImageName", fileExtension: "sk", directoryName: nil, directoryPath: .documentDirectory)
            do {
                encryptedData = try File.read(from: fileUrl)
            } catch { }
            if let data = crypto.decryptString(data: encryptedData) {
                self.mainView.updatImageButton(data: data)
            }
        default: break
            
        }
       
    }
}




