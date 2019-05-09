//
//  AlertMessageService.swift
//  routster
//
//  Created by codefuse on 08.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

class AlertMessageService {
    
//    internal static func showAlertWithBlurredBackground(title: String, body: String, icon: String?, theme: Theme) {
//        let messageView = MessageView.viewFromNib(layout: .cardView)
//        messageView.configureTheme(theme)
//        messageView.configureDropShadow()
//        messageView.configureContent(title: title, body: body, iconImage: nil, iconText: icon, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
//        messageView.button?.isHidden = true
//        var messageConfiguration = SwiftMessages.defaultConfig
//        messageConfiguration.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
//        messageConfiguration.dimMode = .blur(style: .dark, alpha: 1.0, interactive: true)
//        SwiftMessages.show(config: messageConfiguration, view: messageView)
//    }
    
    internal static func showAlertBottom(title: String, body: String, icon: String?, theme: Theme) {
        let messageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(theme)
        messageView.configureDropShadow()
        messageView.configureContent(title: title, body: body, iconImage: nil, iconText: icon, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        messageView.button?.isHidden = true
        var messageConfiguration = SwiftMessages.defaultConfig
        messageConfiguration.presentationStyle = .bottom
        messageConfiguration.duration = .seconds(seconds: 4.0)
        SwiftMessages.show(config: messageConfiguration, view: messageView)
    }
}
