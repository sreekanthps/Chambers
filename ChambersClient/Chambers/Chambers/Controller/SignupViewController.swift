//
//  SingupViewController.swift
//  ChambersCognito
//
//  Created by Swetha Sreekanth on 17/7/20.
//  Copyright © 2020 Brewers. All rights reserved.
//

import UIKit
import Amplify
import Toast_Swift

class  SignupViewController: BaseViewController {
    var userModal : UserModel?
    private var mainView: SignUpView {
        return self.view as! SignUpView
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
    
    override func loadView() {
        let view = SignUpView()
        view.delegate = self
        self.view = view
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        showNavigationBar(titleColor: UIColor.hexColor(Colors.navBar1), barBackGroundColor:UIColor.hexColor(Colors.navBar1))
        configureRightButtonItem(image: "nil")
        configureBackBarButtonItem(image: "backswe")
    }
    
    func signUp(username: String, password: String, email: String) {
        
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        _ = Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            print("signUp.......\(result)")
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details ****** \(String(describing: deliveryDetails))")
                    self.singupConfiormationMessage()
                } else {
                    print("SignUp Complete")
                    self.singupConfiormationMessage()
                    
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
            }
        }
    }
    private func singupConfiormationMessage() {
        DispatchQueue.main.async {
            self.navigationController?.view.makeToast("Sing Up is almsost done, Please used the OTP you have received in your email in next screen", duration: 2.0, position: .center,  completion: { (didTap) in
                print("Testing the toast message")
                self.movetoConfirmation()
            })
        }
    }
    
    private func movetoConfirmation() {
        //DispatchQueue.main.async {
            let confirm = SignupConfirmController(model: self.userModal)
            self.navigationController?.pushViewController(confirm, animated: false)
        //}
    }
    
    override func leftbuttonAction() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension SignupViewController: ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
        switch action {
        case SignUpView.Action.ButtonClick(let model) :
            self.userModal = model
            self.signUp(username: model.userName ?? "", password: model.password ?? "", email: model.email ?? "")
            //self.singupConfiormationMessage()
        default: break
        }
      }
}
