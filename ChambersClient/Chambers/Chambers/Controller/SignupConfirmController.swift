//
//  SignupConfirmController.swift
//  ChambersCognito
//
//  Created by Swetha Sreekanth on 17/7/20.
//  Copyright © 2020 Brewers. All rights reserved.
//

import UIKit
import Amplify

class SignupConfirmController : UIViewController {
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
    }
    func confirmSignUp(for username: String, with confirmationCode: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(_):
                    print("Confirm signUp succeeded")
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
            }
        }
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
