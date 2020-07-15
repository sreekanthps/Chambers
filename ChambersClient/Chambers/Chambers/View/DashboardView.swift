//
//  DashboardView.swift
//  RealmDatabase
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout



class DashboardView: UIView {
   
    private let rootView: UIView = {
      let uiview = UIView()
        uiview.backgroundColor = UIColor.hexColor(Colors.backGround)
      return uiview
    }()
    private let tableContainer = UIView()
    private let plusView =  UIView()
    var tableView = UITableView()
    weak var delegate: TableViewDelegte?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    weak var buttonDelegate: ButtonClickDelegte?
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addDocumentButton(_:)), for: .touchUpInside)
        return button
    }()
    init() {
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    func updateView(nodocuments: Bool = false) {
        tableView.isHidden = nodocuments
        tableView.flex.isIncludedInLayout = !nodocuments
        plusView.isHidden = !nodocuments
        plusView.flex.isIncludedInLayout = nodocuments
        self.layoutSubviews()
        
    }
    private func configure() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.hexColor(Colors.backGround)
        tableView.estimatedRowHeight = 90
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(DashboardRecordCell.self, forCellReuseIdentifier: "DashboardRecordCell")
        tableView.estimatedRowHeight = 90
        
    }
    
    func layout() {
        removeAllSubviewsAndRemoveFromSuperview()
        rootView.flex.define { (flex) in
            flex.addItem(tableView).height(90%).marginHorizontal(15).marginTop(30)
            flex.addItem(plusView).justifyContent(.center).width(100%).height(100%).define { (flex) in
                flex.addItem(plusButton).size(200).alignSelf(.center)
            }
        }
        addSubview(rootView)
    }
    
    @objc func addDocumentButton(_ sender: UIButton) {
        self.buttonDelegate?.buttonPressed()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootView.pin.all()
        rootView.flex.layout()
    }
        
}

extension DashboardView: UITableViewDataSource,UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  delegate?.numberofRows(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardRecordCell", for: indexPath) as? DashboardRecordCell{
            delegate?.cellforRowat(cell: cell, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRowAt(indexPath: indexPath)
    }
    
    
}

