//
//  DashboardRecordCell.swift
//  RealmDatabase
//
//  Created by Swetha Sreekanth on 13/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit

struct DashboardCellData {
    var fileName: String?
    var creationName: String?
    var updateName: String?
}

class DashboardRecordCell : UITableViewCell {
    
    let imgView = UIImageView(frame: .zero)
    let fileName: UILabel = {
        let label = UILabel(frame: .zero)
        
        label.numberOfLines = 2
        // Add font name
        // add font color
        return label
    }()
    let cerationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        // Add font name
        // add font color
        
        return label
    }()
    
    let updated: UILabel = {
        let label = UILabel(frame: .zero)
        // Add font name
        // add font color
        return label
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    func layoutViews() {
        self.contentView.flex.define { (flex) in
            flex.addItem().direction(.row).define { (flex) in
                flex.addItem().justifyContent(.center).define { (flex) in
                    flex.addItem(imgView).width(80).height(80).aspectRatio(of: imgView)
                }
                // Column container
                flex.addItem().direction(.column).marginLeft(10).marginRight(10).grow(1).define { (flex) in
                    flex.addItem(fileName).marginTop(10)
                    flex.addItem(cerationLabel).marginTop(10)
                    flex.addItem(updated).marginTop(10)
                }
            }
            
           
        }
    }
    
    func configureData(data: DashboardCellData) {
        fileName.text = data.fileName ?? ""
        cerationLabel.text = data.creationName ?? ""
        updated.text = data.updateName ?? ""
        
    }
    override func layoutSubviews() {
           super.layoutSubviews()
           layout()
       }
       func layout() {
           contentView.flex.layout(mode: .adjustHeight)
       }

       required init?(coder aDecoder: NSCoder) {
           //fatalError("init(coder:) has not been implemented")
           return nil
       }

       override func sizeThatFits(_ size: CGSize) -> CGSize {
           // 1) Set the contentView's width to the specified size parameter
           contentView.pin.width(size.width)

           // 2) Layout contentView flex container
           layout()

           // Return the flex container new size
           return contentView.frame.size
       }
}