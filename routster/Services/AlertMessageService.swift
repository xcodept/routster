//
//  AlertMessageService.swift
//  routster
//
//  Created by codefuse on 08.05.19.
//  Copyright © 2019 codefuse. All rights reserved.
//

import SwiftMessages

class AlertMessageService {

    // Shows a message alert at the bottom of the screen
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
