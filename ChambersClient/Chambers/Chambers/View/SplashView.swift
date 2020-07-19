//
//  SplashView.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 16/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import UIKit
import Lottie
import FlexLayout
import PinLayout


class SplashView :UIView {
    enum Action: DelegateAction {
       case AnimationComplete
       
    }
    weak var delegate: ActionDelegate?
    var lottieView: AnimationView!
    private let root: UIView = {
      let uiview = UIView()
        uiview.backgroundColor = UIColor.hexColor(Colors.backGround)
      return uiview
    }()
    init() {
        lottieView = AnimationView(name: "safeicon", bundle: Bundle.main)
        super.init(frame: .zero)
        configure()
        loadView()
     }
    func configure() {
       lottieView.loopMode = .playOnce
       lottieView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
       lottieView.contentMode = .scaleToFill
       lottieView.clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    func startLoadAnimation() {
        lottieView.play { (completed) in
            // Imform main scree
            self.delegate?.actionSender(didReceiveAction: Action.AnimationComplete)
        }
    }
    
    
    func loadView() {
        removeAllSubviewsAndRemoveFromSuperview()
        root.flex.define { (flex) in
            flex.addItem().width(100%).height(100%).justifyContent(.center).alignItems(.center).define { (flex) in
                 flex.addItem(lottieView).size(200).alignSelf(.center)
            }
        }
        addSubview(root)
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        // Layout the flexbox container using PinLayout
        // NOTE: Could be also layouted by setting directly rootFlexContainer.frame
        root.pin.all(pin.safeArea)
        
        // Then let the flexbox container layout itself
        root.flex.layout()
    }
}
