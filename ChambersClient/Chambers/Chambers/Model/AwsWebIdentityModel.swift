//
//  AwsWebIdentityModel.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 16/7/20.
//  Copyright © 2020 Citibank. All rights reserved.
//

import Foundation
import AWSCore

struct AwsWebIdentityModel {
    private var duration: Int?
    private var providerId: String?
    private var roleArn: String?
    private var roleSessionName: String?
    private var token: String?
    
    var dictionary: [String: Any] {
        return ["durationSeconds": duration,
                "providerId": providerId,
                "roleArn": roleArn,
                "roleSessionName": roleSessionName,
               "webIdentityToken " : token]
    }
    init(duration: Int? = 900,providerId: String?,roleArn: String?,roleSessionName: String?, token: String?) {
        self.duration = duration
        self.providerId = providerId
        self.roleArn = roleArn
        self.roleSessionName = roleSessionName
        self.token = token
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
}

class WebIdentityModel: AWSSTSAssumeRoleWithWebIdentityRequest {
    init(duration: Int? = 900,providerId: String?,roleArn: String?,roleSessionName: String?, token: String?) {
        super.init()
        self.durationSeconds = NSNumber(value: duration!)
        self.providerId = providerId
        self.roleSessionName = roleSessionName
        self.webIdentityToken = token
    }
    
    required init!(coder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
