//
//  UINavigationHelper.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 12/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit

extension UIViewController {
  func topmostViewController() -> UIViewController {
    if let navigationVC = self as? UINavigationController,
      let topVC = navigationVC.topViewController {
      return topVC.topmostViewController()
    }
    if let tabBarVC = self as? UITabBarController,
      let selectedVC = tabBarVC.selectedViewController {
      return selectedVC.topmostViewController()
    }
    if let presentedVC = presentedViewController {
      return presentedVC.topmostViewController()
    }
    if let childVC = children.last {
      return childVC.topmostViewController()
    }
    return self
  }
    func notifyAlert(_ msg: String, err: String?) {
            let alert = UIAlertController(title: msg,
                message: err,
                preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "OK",
                style: .cancel, handler: nil)

            alert.addAction(cancelAction)

            self.present(alert, animated: true,
                                completion: nil)
        }
}

extension UIApplication {
  func topmostViewController() -> UIViewController? {
    return keyWindow?.rootViewController?.topmostViewController()
  }
}
extension UIView {
    public func removeAllSubviewsAndRemoveFromSuperview() {
        subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }

        removeFromSuperview()
    }

    public func removeAllSubviews() {
        subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
}
