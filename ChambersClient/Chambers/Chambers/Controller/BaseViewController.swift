//
//  BaseViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController {
    
    override func viewDidLoad() {
      super.viewDidLoad()
    }
    
   func showNavigationBar(large: Bool = false,
                            animated: Bool = false,
                            titleColor: UIColor,
                            barBackGroundColor: UIColor) {

        navigationController?.navigationBar.barTintColor = barBackGroundColor
        navigationController?.navigationBar.backgroundColor = barBackGroundColor
        navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if large {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = barBackGroundColor
                appearance.titleTextAttributes = [.foregroundColor: titleColor]
                appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]

                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.compactAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            } else {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
            }
        } else {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        }
    }
    
    @objc func leftbuttonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func rightbuttonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureBackBarButtonItem(image: String?, text: String? = nil) {
        if let img = image {
            let image = UIImage(named: img)?.withRenderingMode(.alwaysOriginal)
            
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.leftbuttonAction))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: text, style: .plain, target: self, action: #selector(self.leftbuttonAction))
        }
    }
    func configureRightButtonItem(image: String?, text: String? = nil) {
        if let img = image {
            let image = UIImage(named: img)?.withRenderingMode(.alwaysOriginal)
            self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.rightbuttonAction))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: text, style: .plain, target: self, action: #selector(self.rightbuttonAction))
        }
    }
}
