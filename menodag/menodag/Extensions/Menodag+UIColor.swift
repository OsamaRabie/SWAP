//
//  Menodag+UIColor.swift
//  menodag
//
//  Created by Osama Rabie on 20/05/2023.
//

import Foundation
import UIKit
import UIGradient

class MenoDagColors {
    /// The gradient colors for the error message based on the user interface style
    static var errorGradientColor:[UIColor] {
        return UIView().traitCollection.userInterfaceStyle == .light ? [.hex("833ab4",alpha: 1),.hex("fd1d1d",alpha: 1),.hex("fcb045")] : [.hex("8E0E00",alpha: 1),.hex("1F1C18",alpha: 1)]
    }
    
    
    /// The gradient colors for the message based on the user interface style
    static var messageGradientColor:[UIColor] {
        return UIView().traitCollection.userInterfaceStyle == .light ? [.hex("135AAD",alpha: 1),.hex("41A4FF",alpha: 1),.hex("FFFFFF")] : [.hex("6B6B6B",alpha: 1),.hex("000000",alpha: 1)]
    }
}

/// Defines which type of messages we are going to show
enum MessageType {
    /// Means, an error message
    case Error
    /// Means, an info message
    case Message
    
    /// returns the correct background color based on the message type
    func messageColor() -> [UIColor] {
        switch self {
        case .Error:
            return MenoDagColors.errorGradientColor
        case .Message:
            return MenoDagColors.messageGradientColor
        }
    }
}
