//
//  DashboardViewController.swift
//  RealmDatabase
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol TableViewDelegte: class {
   @objc func numberofRows(section: Int) -> Int
   @objc func cellforRowat(cell: Any?, indexPath: IndexPath)
   @objc func numberOfSections() -> Int
   @objc func didSelectRowAt(indexPath: IndexPath)
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
        updateDashBord()
        navigationController?.setNavigationBarHidden(false, animated: false)
                let navModel = NavigationModel(title: "", lbTitle: nil, rbTitle: "adddocsmall", barTintColor: UIColor.hexColor(Colors.backGround), titleColor: .black, lbTintColor: .black, rbTintColor: .black, rbWidth: 40)
                //self.setupNavigationBar(navModel: navModel)
               self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "adddocsmall"), style: .plain, target: self, action: #selector(addRecords))
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
        //                                                                 target: self, action: #selector(addRecords))
               self.navigationItem.backBarButtonItem = nil
        
        
    }
    private func updateDashBord() {
        if let data = fileData {
            self.mainView.updateView(nodocuments: data.count > 1 ? false : true)
        }
    }
    init() {
        super.init(nibName: nil, bundle: Bundle.main)
        fileData = try! Realm().objects(DocumentStore.self).sorted(byKeyPath: "timestamp")
   
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
    @objc func addRecords() {
        // Take the user to new Screen
        let newDocument = NewDocumentController()
        self.navigationController?.pushViewController(newDocument, animated: false)
    }
}

extension DashboardViewController: TableViewDelegte {
    func numberOfSections() -> Int {
        return 0
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        // Add code to show details page
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
            celldata.configureData(data: DashboardCellData(fileName: rec.documentName, creationName: String(rec.timestamp), updateName: String(rec.timestamp)),isLast: indexPath.row == (data.count - 1) ? true: false )
        }
    }
    
}

extension DashboardViewController: ButtonClickDelegte {
    func buttonPressed() {
        self.addRecords()
    }
}
