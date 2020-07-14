//
//  BaseViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController {
    
    override func viewDidLoad() {
      super.viewDidLoad()
    }
    
    public func setupNavigationBar(navModel: NavigationModel) {
        //titleColor = hexColor(Colors.bc1)
        //showDropDownShadowForNavigationBar(UIColor.clear)
        self.title = navModel.title ?? ""
        let nav = self.navigationController?.navigationBar
        nav?.isTranslucent = false
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.hexColor(Colors.bc1),NSAttributedString.Key.font: UIFont.getSfProTextMediumStyle(18)]
        nav?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav?.shadowImage = UIImage()
        nav?.shadowImage = nil

        nav?.barTintColor = navModel.barTintColor
        nav?.tintColor = navModel.barTintColor
        if let lbButonTitle = navModel.lbTitle {
            leftBarBtnItem(lbButonTitle, titleColor: UIColor.hexColor(Colors.bc7))
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
        if let rbTitle = navModel.rbTitle {
            var rightItemTintColor:UIColor =  UIColor.hexColor(Colors.bc3)
            if let _ = UIImage(named: rbTitle){
                rightItemTintColor = UIColor.hexColor(Colors.bc7)
            }
            rightBarBtnItem(rbTitle, titleColor: rightItemTintColor)
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        if #available(iOS 13.0, *) {
            //configureNavigation()
        }
        
    }
    @available(iOS 13.0, *)
    func configureNavigation() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    public func showDropDownShadowForNavigationBar(_ color: UIColor)  {
        self.navigationController?.navigationBar.layer.shadowColor = color.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 1.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    func leftBarBtnItem(_ title: String, titleColor: UIColor?) {
        let btnleft: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btnleft.contentHorizontalAlignment = .left
        btnleft.setTitleColor(titleColor != nil ? titleColor : UIColor.white, for: .normal)
        if let image = UIImage(named: title) {
            btnleft.setImage(image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            btnleft.tintColor = titleColor ?? UIColor.white
        } else {
            btnleft.setTitle(title, for: .normal)
        }
        btnleft.addTarget(self, action: #selector(self.leftButtonAction(sender:)), for: .touchDown)
        let backBarButon: UIBarButtonItem = UIBarButtonItem(customView: btnleft)
        self.navigationItem.setLeftBarButton(backBarButon, animated: true)
    }

    func rightBarBtnItem(_ title: String, titleColor: UIColor?, rightButtonWidth: CGFloat? = 60) {
        var frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        if let width = rightButtonWidth,  UIImage(named: title) == nil {
            var size = frame.size
            size.width = width
            frame.size = size
        }
        let btnright: UIButton = UIButton(frame: frame)
        btnright.setTitleColor(titleColor != nil ? titleColor : UIColor.white, for: .normal)
        btnright.contentHorizontalAlignment = .right
        if let image = UIImage(named: title) {
            btnright.setImage(image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            btnright.tintColor = titleColor ?? UIColor.white
            btnright.setTitleColor(UIColor.hexColor(Colors.bc1), for: .highlighted)
        } else {
            btnright.setTitle(title, for: .normal)
            btnright.titleLabel?.font = UIFont.getSfProTextMediumStyle(14)
            btnright.sizeToFit()
        }
        btnright.addTarget(self, action: #selector(self.rightButtonAction(sender:)), for: .touchDown)
        let rightbackBarButon: UIBarButtonItem = UIBarButtonItem(customView: btnright)
        self.navigationItem.setRightBarButton(rightbackBarButon, animated: true)
    }
    
    // MARK: - Left Button Action methods
    // Override method if you want to add any custom action
    @objc open func leftButtonAction(sender: UIButton?) {
            self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Right Button Action methods
    // Override method if you want to add any custom action
    @objc open func rightButtonAction(sender: UIButton?) {
            self.navigationController?.popViewController(animated: true)
    }
    
    
}
