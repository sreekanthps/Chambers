//
//  BioMetircAuthentication.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 13/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import LocalAuthentication

enum AuthenticationType {
    case FACE
    case FINGURE
    case KEYPAD
    case NONE
}

class BioMetircAuthentication {
    var parentVC: UIViewController? 
    init(viewControler: UIViewController?) {
        self.parentVC = viewControler
    }
     let context = LAContext()
     var error: NSError?
     func canEvaluatePolicy(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics) -> AuthenticationType {
        var policyFlag: AuthenticationType = .NONE
        if context.canEvaluatePolicy(
        LAPolicy.deviceOwnerAuthenticationWithBiometrics,
             error: &error) {
            if (context.biometryType == LABiometryType.faceID) {
                    // Device support Face ID
                policyFlag = .FACE
               } else if context.biometryType == LABiometryType.touchID {
                    // Device supports Touch ID
                    policyFlag = .FINGURE
               } else {
                policyFlag = .KEYPAD
                    // Device has no biometric support
              }
            
        } else {
            policyFlag = .NONE
            evaluatePolicyError(error: error)
        }
        return policyFlag
    }
    
    func evaluatePolicy(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics)  -> Bool {
        var authStatus: Bool = false
        context.localizedFallbackTitle = "Authenticate with Device passcode"
        context.evaluatePolicy(policy,
            localizedReason: "Access requires authentication",
            reply: {(success, error) in
                DispatchQueue.main.async {
                    if let err = error {
                        print("evaluatePolicy Error...\(err.localizedDescription)")
                        switch err._code {
                        case LAError.Code.authenticationFailed.rawValue:
                            self.notifyUser("Authentication Failed",
                                            err: err.localizedDescription)
                        case LAError.Code.systemCancel.rawValue:
                            self.notifyUser("Session cancelled",
                                            err: err.localizedDescription)
                        case LAError.Code.userCancel.rawValue:
                            self.notifyUser("Please try again",
                                            err: err.localizedDescription)
                            
                        case LAError.Code.userFallback.rawValue:
                            self.notifyUser("Authentication",
                                            err: "Password option selected")
                            // Custom code to obtain password here
                        
                        default:
                            self.notifyUser("Authentication failed",
                                            err: err.localizedDescription)
                        }
                        
                    } else {
                        authStatus =  true
                    }
                }
        })
        return authStatus
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
            message: err,
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "OK",
            style: .cancel, handler: nil)

        alert.addAction(cancelAction)

        self.parentVC?.present(alert, animated: true,
                            completion: nil)
    }
    
    private func evaluatePolicyError(error: NSError?) {
        var errorMessage = "Showing Error message"
        if let err = error {
                switch err.code{
                case LAError.Code.biometryNotEnrolled.rawValue:
                    errorMessage = "User is not enrolled"
                case LAError.Code.passcodeNotSet.rawValue:
                     errorMessage = "A passcode has not been set"
                case LAError.Code.biometryNotAvailable.rawValue:
                    errorMessage = "Biometric authentication not available"
                   default:
                    notifyUser("Unknown error",
                           err: err.localizedDescription)
            }
            notifyUser(errorMessage, err: err.localizedDescription)
        }
    }
}

