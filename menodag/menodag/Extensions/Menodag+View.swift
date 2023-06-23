//
//  Menodag+View.swift
//  menodag
//
//  Created by Osama Rabie on 20/05/2023.
//

import Foundation
import UIKit
import SwiftMessages
import UIGradient

extension UIView {
    
    /// Displays an error message on top of the provided view
    /// - Parameter message: The error message we need to show
    /// - Parameter title: The error title we need to show
    /// - Parameter messageType: The message type to display
    func showError(title:String, message:String, messageType:MessageType) {
        var config = SwiftMessages.Config()
        
        config.dimMode = .blur(style: .systemThinMaterial, alpha: 0.75, interactive: true)
        let view = MessageView.viewFromNib(layout: .cardView)
        // Theme message elements with the error style.
        view.configureTheme(backgroundColor: UIColor.fromGradientWithDirection(.leftToRight, frame: view.frame, colors: messageType.messageColor()) ?? .white, foregroundColor: .white)
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        view.button?.backgroundColor = .clear
        // Show the message.
        SwiftMessages.show(config:config, view: view)
    }
}
