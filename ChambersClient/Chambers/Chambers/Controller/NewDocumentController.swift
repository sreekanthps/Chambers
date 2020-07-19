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
import RealmSwift
import MobileCoreServices
import Amplify
import AmplifyPlugins
import Toast_Swift
enum ContentType: String {
    case PNGIMAGE = "png"
    case JPEGIMAGE = "jpeg"
    case PDF = "pdf"
    case WORD = "docx"
    case EXCEL = "xlsx"
    case OTHER = "other"
    
}

enum Storage: String {
    case LOCAL = "local"
    case CLOUD = "cloud"
}

class NewDocumentController: BaseViewController {
    var storage: Storage = .LOCAL
    var time: Int64 = 0
    var status: FileStatus = .PLAIN
    let realm = try! Realm()
    var fileName : String = ""
    var image: UIImage? = nil
    var fileModel: FileModel? = nil
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
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Sreekanth"
        showNavigationBar(titleColor: UIColor.hexColor(Colors.navBar1), barBackGroundColor: UIColor.hexColor(Colors.navBar1))
        configureBackBarButtonItem(image: "backswe")
    }
    
    
    override func loadView() {
        let view = NewDocumentView()
        view.delegate = self
        self.view = view
    }
    
    func showPhotoMenu() {
        let actions = [ "Select From Folder",
                        "Choose Existing Photo",
                       "Take Photo",
                       "CANCEL"]
        UtilitiesHelper.presentActionSheet(nil, message: nil, actions: actions, controller: self) { (alertVC, selectedAction) in
            alertVC.dismiss(animated: true, completion: nil)
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if selectedAction == "Choose Existing Photo" {
                               self.authorisationStatus(type: .photoLibrary)
                           } else if selectedAction == "Take Photo" {
                               self.authorisationStatus(type: .camera)
                           } else if selectedAction == "Select From Folder" {
                            self.openFolderApplication()
                          }
                       }
        }
    }
    
    @objc func showUploadMenu() {
        if status == .ENCRYPTED {
           let actions = [ "Save To Device",
                           "Save To Cloud",
                          "CANCEL"]
           UtilitiesHelper.presentActionSheet(nil, message: nil, actions: actions, controller: self) { (alertVC, selectedAction) in
               alertVC.dismiss(animated: true, completion: nil)
                          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                           if selectedAction == "Save To Device" {
                                  self.saveDocumentInLocal()
                              } else if selectedAction == "Save To Cloud" {
                                  // Need to implement cloud upload
                                  self.time = Date().unixTimestamp
                                  self.writeFileDetailstoDB(time: self.time,storage: .CLOUD)
                                  self.uploadDatatoCloud()
                              }
                          }
           }
        } else {
            self.notifyAlert("Encryption Error", err: "Please Encrypt the file before Upload")
        }
    }
    
    
    private func saveDocumentInLocal() {
        time = Date().unixTimestamp
        let loginModel = LoginModel.shared
        if let encryptedData = fileModel?.encryptedData, let name = fileModel?.fileName, let userId = loginModel.userID {
            fileName =  userId + "_" + String(time) + "_" + name
            let fileUrl = FileURLComponents(fileName: fileName, fileExtension: "sk", directoryName: nil, directoryPath: .documentDirectory)
                do {
                      _ = try File.write(encryptedData, to: fileUrl)
                    self.displayToastMessage(message: "File Saved locally on device")
                    writeFileDetailstoDB(time: self.time,storage: .LOCAL)
                } catch {
                   
                }
            }
        }
    
    private func writeFileDetailstoDB(time: Int64 = 0, storage: Storage ) {
        let documents = realm.objects(DocumentStore.self)
        let login = LoginModel.shared
        let id = documents.count > 0 ? documents.count + 1 : 1
        
        try! realm.write {
            let document = DocumentStore(id: id, documentName: fileModel?.fileName ?? "", timestamp: Date().unixTimestamp, fileType: fileModel?.fileExtension ?? "JPEG", datecreation: Date(),userId: login.userID,updatedDate: Date(),updateTime: Date().unixTimestamp,storage: self.storage.rawValue)
            realm.add(document)
            try! realm.commitWrite()
        }
        
    }
    
    func uploadDatatoCloud(time: Int64 = 0) {
        let loginModel = LoginModel.shared
        if let encryptedData = fileModel?.encryptedData, let name = fileModel?.fileName, let userId = loginModel.userID {
            fileName =  userId + "_" + String(time) + "_"  + name
            self.spinnerView = self.showSpinner(onView: self.view)
            _ = Amplify.Storage.uploadData(key: fileName, data: encryptedData,
                      progressListener: { progress in
                          print("Progress: \(progress)")
                      }, resultListener: { (event) in
                          switch event {
                          case .success(let data):
                              print("Completed: \(data)")
                              self.removeSpinner(childView: self.spinnerView!)
                              self.displayToastMessage(message: "File Uploaded to Cloud", time: 1.0)
                              //self.writeFileDetailstoDB()
                          case .failure(let storageError):
                              print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                      }
                  })
        }
       
    }
    
    private func displayToastMessage(message: String, time: TimeInterval = 1.0) {
        DispatchQueue.main.async {
            self.navigationController?.view.makeToast(message, duration: time, position: .center,  completion: { (didTap) in
                
            })
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
                self.notifyAlert("Chambers Error", err: "Sorry, seems like you have not given permission for Digibank app to access your phone's camera.")
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
                self.notifyAlert("Chambers Error", err: "Sorry, seems like you have not given permission for Digibank app to access your phone's gallery.")
            @unknown default:
                fatalError()
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
    func openFolderApplication() {
        let pickerController = UIDocumentPickerViewController(documentTypes: ["public.data",kUTTypePDF as String, kUTTypeImage as String], in: .open)
        pickerController.delegate = self
        pickerController.allowsMultipleSelection = false
        present(pickerController, animated: true)
    }
}

extension NewDocumentController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL,
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
    
        fileModel = FileModel(fileName: fileUrl.lastPathComponent, fileExtension: fileUrl.pathExtension, fileData: selectedImage.pngData(), fileImage: selectedImage,contentType: ContentType(rawValue: fileUrl.pathExtension))
        picker.dismiss(animated: false, completion: { () -> Void in
            self.image = selectedImage
            self.updateRightBarbuttonItem()
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mainView.updateDecryptButton(fileModel: self.fileModel)
          }
          
        })

    }
    func encryptData() {
        if let content = fileModel?.contentType, [ContentType.PNGIMAGE,ContentType.JPEGIMAGE].contains(content),let image = fileModel?.fileImage , let imageData =  image.pngData(),let encrpytedData = crypto.encryptData(plainData: imageData) {
            fileModel?.encryptedData = encrpytedData
            status = .ENCRYPTED
            self.mainView.updateEncryptedView()
        } else if let image = fileModel?.fileData , let encrpytedData = crypto.encryptData(plainData: image) {
            fileModel?.encryptedData = encrpytedData
            status = .ENCRYPTED
            self.mainView.updateEncryptedView()
        }
        
        
    }
    func decryptData() {
        if let encryptedData = fileModel?.encryptedData, let plaindata = crypto.decryptString(data: encryptedData) {
            status = .PLAIN
            if let contentType = fileModel?.contentType, [ContentType.PNGIMAGE,ContentType.JPEGIMAGE].contains(contentType),let image  = UIImage(data: plaindata) {
                    self.mainView.updateDecryptedView(image: image)
            } else {
                let image = UIImage(named: fileModel?.getImageAssetType() ?? "warning")
                   self.mainView.updateDecryptedView(image: image)
            }
        }
       
    }
    private func updateRightBarbuttonItem() {
        let image = UIImage(named: "upload")?.withRenderingMode(.alwaysOriginal)
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.showUploadMenu))
    }
}

extension NewDocumentController: ActionDelegate {
    public func actionSender(didReceiveAction action: DelegateAction) {
        switch action {
        case NewDocumentView.Action.AddButtonClick :
             self.showPhotoMenu()
        case NewDocumentView.Action.EncryptButtonClick :
            self.encryptData()
        case NewDocumentView.Action.DecryptButtonClick :
            self.decryptData()
        case NewDocumentView.Action.UploadButtonClick(let isUploaded) :
            if isUploaded {
               showUploadMenu()
            } else {
                self.notifyAlert("Encryption Error", err: "Please Encrypt the file before Upload")
            }
        default: break
            
        }
       
    }
}

extension NewDocumentController : UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        documentFromURL(pickedURL: url)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Document Picker got cancelled
    }
    
    private func documentFromURL(pickedURL: URL) {
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }
            NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
            do {
                var image: UIImage?
                let data = try Data(contentsOf: pickedURL)
                if ["png","jpeg"].contains(pickedURL.pathExtension) {
                    image = UIImage(data: data)
                }
                self.fileModel = FileModel(fileName: pickedURL.lastPathComponent, fileExtension: pickedURL.pathExtension, fileData: data, fileImage: image, contentType: ContentType.init(rawValue: pickedURL.pathExtension))
                   self.updateRightBarbuttonItem()
                   self.mainView.updateDecryptButton(fileModel: self.fileModel)
                } catch let error { print("error: ", error.localizedDescription) }

            }
    }
}
