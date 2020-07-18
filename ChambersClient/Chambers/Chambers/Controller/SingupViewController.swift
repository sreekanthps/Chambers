//
//  SingupViewController.swift
//  ChambersCognito
//
//  Created by Swetha Sreekanth on 17/7/20.
//  Copyright © 2020 Brewers. All rights reserved.
//

import UIKit
import Amplify

class  SingupViewController: UIViewController {
    var userModal : UserModel?
    private var mainView: SingUpView {
        return self.view as! SingUpView
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
        let view = SingUpView()
        view.delegate = self
        self.view = view
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                    self.movetoConfirmation()
                } else {
                    print("SignUp Complete")
                    self.movetoConfirmation()
                    
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
            }
        }
    }
    
    private func movetoConfirmation() {
        DispatchQueue.main.async {
            let confirm = SignupConfirmController(model: self.userModal)
                   self.navigationController?.pushViewController(confirm, animated: false)
        }
    }
    
}

extension SingupViewController: ActionDelegate {
    func actionSender(didReceiveAction action: DelegateAction) {
        switch action {
        case SingUpView.Action.ButtonClick(let model) :
            self.userModal = model
            self.signUp(username: model.userName ?? "", password: model.password ?? "", email: model.email ?? "")
        default: break
        }
      }
}
