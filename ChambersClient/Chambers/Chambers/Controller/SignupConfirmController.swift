//
//  SignupConfirmController.swift
//  ChambersCognito
//
//  Created by Swetha Sreekanth on 17/7/20.
//  Copyright © 2020 Brewers. All rights reserved.
//

import UIKit
import Amplify
import Toast_Swift

class SignupConfirmController : BaseViewController {
    var userModal: UserModel?
    private var mainView: SignUpConfirmView {
        return self.view as! SignUpConfirmView
    }
    
    init(model: UserModel?) {
        self.userModal = model
        super.init(nibName: nil, bundle: Bundle.main)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func loadView() {
        let view = SignUpConfirmView()
        view.delegate = self
        self.view = view
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        showNavigationBar(titleColor: UIColor.hexColor(Colors.navBar1), barBackGroundColor:UIColor.hexColor(Colors.navBar1))
        configureRightButtonItem(image: "nil")
        configureBackBarButtonItem(image: "backswe")
        self.title = "Sreekanth"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white]
    }
    func confirmSignUp(for username: String, with confirmationCode: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(_):
                self.gobacktoLoginPage()
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
            }
        }
    }
    private func gobacktoLoginPage() {
        DispatchQueue.main.async {
            self.navigationController?.view.makeToast("Sing Up is complete, Please use the User ID and password to  Login", duration: 2.0, position: .center,  completion: { (didTap) in
                print("Testing the toast message")
                self.movetoConfirmation()
            })
        }
    }
    private func movetoConfirmation() {
        if let loginVC = self.navigationController?.viewControllers.filter({ return $0 is AWSLoginController }).first {
            self.navigationController?.popToViewController(loginVC, animated: false)
        }
    }
    override func leftbuttonAction() {
        self.movetoConfirmation()
    }
}
extension SignupConfirmController: ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
      switch action {
      case SignUpConfirmView.Action.ButtonClick(let code) :
          print("complete the sing up")
          let userName = self.userModal?.userName ?? ""
          let confirmcode = code ?? ""
          self.confirmSignUp(for: userName, with: confirmcode)
          //self.signUp(username: model.userName ?? "", password: model.password ?? "", email: model.email ?? "")
      default: break
      }
    }
}
