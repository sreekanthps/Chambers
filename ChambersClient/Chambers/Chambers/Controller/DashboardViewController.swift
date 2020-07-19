//
//  DashboardViewController.swift
//  RealmDatabase
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit
import RealmSwift
import Amplify

@objc protocol TableViewDelegte: class {
   @objc func numberofRows(section: Int) -> Int
   @objc func cellforRowat(cell: Any?, indexPath: IndexPath)
   @objc func numberOfSections() -> Int
   @objc func didSelectRowAt(indexPath: IndexPath)
  @objc optional func didDeleteRecord(indexPath: IndexPath)
}

@objc protocol ButtonClickDelegte: class {
   @objc func buttonPressed()
 }

class DashboardViewController: BaseViewController {
    var fileData: Results<DocumentStore>?
    let realm = try! Realm()
    
    fileprivate var mainView : DashboardView {
        return self.view as! DashboardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fileData = try! Realm().objects(DocumentStore.self).sorted(byKeyPath: "timestamp")
        updateDashBord()
        navigationController?.setNavigationBarHidden(false, animated: false)
        showNavigationBar(titleColor: UIColor.hexColor(Colors.navBar1), barBackGroundColor: UIColor.hexColor(Colors.navBar1))
        configureRightButtonItem(image: "addplus")
        configureBackBarButtonItem(image: "exit1")
        
   }
  
    private func updateDashBord() {
        let count = fileData?.count ?? 0
        if count > 0 {
            self.mainView.tableView.reloadData()
        }
        self.mainView.updateView(nodocuments: count > 0 ? false : true)

    }
    init() {
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        let view = DashboardView()
        view.delegate = self
        view.buttonDelegate = self
        self.view = view
    }
    override func rightbuttonAction() {
        addRecords()
    }
    @objc func addRecords() {
        let newDocument = NewDocumentController()
        newDocument.modalPresentationStyle = UIModalPresentationStyle.popover
        self.navigationController?.pushViewController(newDocument, animated: false)
    }
    override func leftbuttonAction() {
            _ = Amplify.Auth.signOut() { result in
                switch result {
                case .success:
                    DispatchQueue.main.async{
                        self.navigationController?.popViewController(animated: false)
                    }
                case .failure(let error):
                    print("Sign out failed with error \(error)")
                }
            }
        }
    private func deleteRealObject(index: Int) {
        if let record = fileData?[index] {
            if let userID = LoginModel.shared.userName, let name = record.documentName {
                let recrodName = userID + name
                let fileUrl = FileURLComponents(fileName: recrodName, fileExtension: "sk", directoryName: nil, directoryPath: .documentDirectory)
                    do {
                        _ = try File.delete(fileUrl)
                    } catch {
                       
                    }
            }
            try! realm.write {
                realm.delete(record)
            }
            fileData = try! Realm().objects(DocumentStore.self).sorted(byKeyPath: "timestamp")
        }
        
           
    }
    
}

extension DashboardViewController: TableViewDelegte {
    func numberOfSections() -> Int {
        return 0
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        if let data = fileData {
            let rec = data[indexPath.row]
            let viewVC = DocumentViewController(document: rec)
            self.navigationController?.pushViewController(viewVC, animated: false)
        }
        
    }
    
    func numberofRows(section: Int) -> Int {
        if let data = fileData, data.count > 0 {
            return data.count
        }
        return 0
    }
    
    func cellforRowat(cell: Any?, indexPath: IndexPath) {
        if let celldata = cell as? DashboardRecordCell,  let data = fileData {
            let rec = data[indexPath.row] 
            celldata.configureData(data: DashboardCellData(fileName: rec.documentName, creationName: rec.datecreation?.toString(dateFormat: DateFormat.ddMMMyyyy), updateName: rec.dateUpdation?.toString(dateFormat: DateFormat.ddMMMyyyy), imageName: rec.getImageforFileType()),isLast: indexPath.row == (data.count - 1) ? true: false )
        }
    }
    func didDeleteRecord(indexPath: IndexPath) {
        self.deleteRealObject(index: indexPath.row)
    }
    
}

extension DashboardViewController: ButtonClickDelegte {
    func buttonPressed() {
        self.addRecords()
    }
}
