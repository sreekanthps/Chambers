//
//  LoginModel.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import Foundation
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit


class LoginModel {
    static let shared = LoginModel()
    var tokenId: String?
    var userName: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    private init() {

       }
    required public init?(loginResponse: GIDGoogleUser?) {
        if let token = loginResponse?.authentication.idToken {
            tokenId = token
        }
        if let mail = loginResponse?.profile.email {
            email = mail
        }
    }
    
    required public init?(loginResponse: LoginManagerLoginResult?) {
        if let token = loginResponse?.token?.tokenString {
            tokenId = token
        }
    }
    
}
