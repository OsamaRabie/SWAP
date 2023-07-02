//
//  Menodag+View.swift
//  menodag
//
//  Created by Osama Rabie on 20/05/2023.
//

import Foundation
import UIKit
import Toast

extension UIView {
    
    /// Displays an error message on top of the provided view
    /// - Parameter message: The error message we need to show
    /// - Parameter title: The error title we need to show
    func showError(title:String, message:String = "") {
        
        let titleAttributes = [
            NSAttributedString.Key.font: MenodagFont.localizedFont(for: .PoppinsMedium, with: 14),
            NSAttributedString.Key.foregroundColor: UIColor(named: "AppBlackColor") ?? .black
        ]
        
        let messageAttributes = [
            NSAttributedString.Key.font: MenodagFont.localizedFont(for: .PoppinsRegular, with: 12),
            NSAttributedString.Key.foregroundColor: UIColor(named: "AppBlackColor") ?? .black
        ]
        
        let toast:Toast = Toast.text(NSAttributedString(string: title,attributes: titleAttributes), subtitle: ( message == "" ) ? nil : NSAttributedString(string: message, attributes: messageAttributes), config: ToastConfiguration())
        DispatchQueue.main.async {
            toast.show()
        }
    }
}
