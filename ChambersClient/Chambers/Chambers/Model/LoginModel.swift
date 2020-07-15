//
//  LoginModel.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
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
    var userID: String?
    var expiration: Date?
    private init() {

       }
    required public init?(loginResponse: GIDGoogleUser?) {
        if let token = loginResponse?.authentication.idToken {
            tokenId = token
        }
        if let mail = loginResponse?.profile.email {
            email = mail
        }
        userName = loginResponse?.profile.name
        firstName = loginResponse?.profile.familyName
        lastName = loginResponse?.profile.givenName
        userID = loginResponse?.userID
        LoginModel.shared.tokenId = tokenId
        LoginModel.shared.email = email
        LoginModel.shared.userName = userName
        LoginModel.shared.lastName = lastName
        LoginModel.shared.userID = userID
    }
    
    required public init?(loginResponse: LoginManagerLoginResult?) {
        if let token = loginResponse?.token?.tokenString {
            tokenId = token
        }
        if let userId = loginResponse?.token?.userID {
          userID = userId
        }
        expiration = loginResponse?.token?.expirationDate
        LoginModel.shared.tokenId = tokenId
        LoginModel.shared.userID = userID
    }
    
}
