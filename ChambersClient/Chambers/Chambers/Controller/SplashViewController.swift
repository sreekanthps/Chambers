//
//  SpalshViewController.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 16/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
     private var mainView: SplashView {
        return self.view as! SplashView
    }

    init() {
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func navigateToDashBoard() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (nil) in
             let newVC = LoginViewController()
            self.navigationController?.pushViewController(newVC, animated: false)
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    override func loadView() {
        let view = SplashView()
        view.delegate = self
        self.view = view
    }
    
    func startAnimation() {
        mainView.startLoadAnimation()
    }
    
}

extension SplashViewController: ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
        switch action {
        case SplashView.Action.AnimationComplete :
            self.navigateToDashBoard()
         default: break
        }
        
    }
}
