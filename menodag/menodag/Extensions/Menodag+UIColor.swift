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
}
