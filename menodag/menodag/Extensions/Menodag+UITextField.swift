//
//  Menodag+UITextField.swift
//  menodag
//
//  Created by Osama Rabie on 29/06/2023.
//

import Foundation
import UIKit

extension UITextField {
    /// Will set an icon in the left side of the textField
    func setIcon(image: UIImage, width:CGFloat) {
        let padding: CGFloat = 8
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: padding * 2 + width, height: width))
        let imageView = UIImageView(frame: CGRect(x: padding, y: 0, width: width, height: width))
        imageView.image = image
        outerView.addSubview(imageView)
        leftView = outerView // Or rightView = outerView
        leftViewMode = .always // Or rightViewMode = .always
    }
}
