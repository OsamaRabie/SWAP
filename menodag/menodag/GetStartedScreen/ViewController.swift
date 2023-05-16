//
//  ViewController.swift
//  menodag
//
//  Created by Osama Rabie on 13/05/2023.
//

import UIKit
import MOLH

class ViewController: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var subHeaderTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var toBeLocalizedViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setFonts()
        setTheme()
        setContent()
        setDirections()
    }
}

/// Theme based methods
extension ViewController {
    /// setting the fonts for all the related sub views
    func setFonts() {
        // Labels
        headerTitleLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 32)
        subHeaderTitleLabel.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        
        // TextFields
        emailTextField.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        passwordTextField.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        emailTextField.attributedPlaceholder = NSAttributedString(string:sharedLocalisationManager.localization.textFieldPlaceHolders.email, attributes:[.foregroundColor: UIColor(named: "TextFieldsFontColor") ?? .black ,.font : MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:sharedLocalisationManager.localization.textFieldPlaceHolders.password, attributes:[.foregroundColor: UIColor(named: "TextFieldsFontColor") ?? .black ,.font : MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)])
        
    }
    
    /// Adjust the theme needed values
    func setTheme() {
        // bg colors
        emailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        
        // corner radius
        emailTextField.layer.cornerRadius = 24
        passwordTextField.layer.cornerRadius = 24
        
        // borders
        emailTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor(named: "BorderGreyColor")?.cgColor
        passwordTextField.layer.borderColor = UIColor(named: "BorderGreyColor")?.cgColor
        emailTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true
    }
    
    /// sets the textual contents for the different parts
    func setContent() {
        headerTitleLabel.text = sharedLocalisationManager.localization.getStarted.header
        subHeaderTitleLabel.text = sharedLocalisationManager.localization.getStarted.subHeader
    }
    
    /// sets the RTL/LTR directions
    func setDirections() {
        // Correct view aligment
        let viewAlignment:UISemanticContentAttribute = MOLHLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
        // Correct text aligment
        let textAlignment:NSTextAlignment = MOLHLanguage.isArabic() ? .right : .left
        toBeLocalizedViews.forEach{ $0.semanticContentAttribute = viewAlignment }
        toBeLocalizedViews.forEach { view in
            if let textView:UITextView = view as? UITextView {
                textView.textAlignment = textAlignment
            }else if let textField:UITextField = view as? UITextField {
                textField.textAlignment = textAlignment
            }
        }
    }
}

