//
//  UtilitiesHelper.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 9/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit

typealias AlertControllerCompletionHandler = (UIAlertController, String?) -> Void

class UtilitiesHelper {
    
    class func presentActionSheet(_ title: String?, message: String?,
                            actions: [String],controller: UIViewController ,completionBlock: @escaping AlertControllerCompletionHandler) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for actionName in actions {
            var alertStyle = UIAlertAction.Style.default
            var btnColor : UIColor = UIColor.hexColor(Colors.keyboardToolbarBlue)
            if actionName == "CANCEL" {
                alertStyle = UIAlertAction.Style.cancel
            } else if actionName.contains("Delete") {
                alertStyle = UIAlertAction.Style.destructive
                btnColor = UIColor.hexColor(Colors.Button.delete)
            }
            let alertAction = UIAlertAction(title: actionName, style: alertStyle, handler: { (action) in
                completionBlock(alertController, action.title)
            })
            alertAction.setValue(btnColor, forKey: "titleTextColor")
           alertController.addAction(alertAction)
        }
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func getTopViewController(_ shouldForceAsNavVC: Bool? = false) -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate
        if let window = appDelegate!.window {
            func getTheVC(_ view: UIViewController) -> UIViewController? {
                if shouldForceAsNavVC ?? false {
                    if let navVC = view.navigationController {
                        return navVC
                    } else {
                        print("shouldForceAsNavVC is true but vc.navigationController is nil, So returning vc")
                        return view
                    }
                } else {
                    return view
                }
            }
        }
        return nil
    }
    
}
