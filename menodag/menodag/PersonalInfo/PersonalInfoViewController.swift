//
//  PersonalInfoViewController.swift
//  menodag
//
//  Created by Osama Rabie on 23/06/2023.
//

import UIKit
import SSSpinnerButton
import MOLH

class PersonalInfoViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: SSSpinnerButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet var toBeLocalizedViews: [UIView]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processLocalisationFontsAligments()
        SwapFirebaseUsers.fetchUser()
    }
    
    /// Responsible for setting the correct content localistion, localised fonts & language based directions
    func processLocalisationFontsAligments() {
        setFonts()
        setTheme()
        setContent()
        setDirections()
    }
}



//MARK: Theme based methods
extension PersonalInfoViewController {
    /// setting the fonts for all the related sub views
    func setFonts() {
        // Labels
        headerLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 32)
        subHeaderLabel.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        
        // TextFields
        toBeLocalizedViews.compactMap{ $0 as? UITextField }.forEach { textField in
            // set the font
            textField.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
            // set the font color
            textField.textColor = UIColor(named: "TextFieldsFontColor") ?? .black
            // decide the placeholder
            var placeHolderText:String = ""
            if textField == firstNameTextField {
                placeHolderText = sharedLocalisationManager.localization.textFieldPlaceHolders.firstName
            }else if textField == lastNameTextField {
                placeHolderText = sharedLocalisationManager.localization.textFieldPlaceHolders.lastName
            }else if textField == phoneNumberTextField {
                placeHolderText = sharedLocalisationManager.localization.textFieldPlaceHolders.phone
            }else if textField == emailAddressTextField {
                placeHolderText = sharedLocalisationManager.localization.textFieldPlaceHolders.email
            }else if textField == userNameTextField {
                placeHolderText = sharedLocalisationManager.localization.textFieldPlaceHolders.userName
            }
            textField.attributedPlaceholder = NSAttributedString(string:placeHolderText, attributes:[.foregroundColor: UIColor(named: "AppGreyColor") ?? .black ,.font : MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)])
        }
        
        // Buttons
        continueButton.titleLabel?.font = MenodagFont.localizedFont(for: .PoppinsMedium, with: 18)
    }
    
    /// Adjust the theme needed values
    func setTheme() {
        // TextFields
        toBeLocalizedViews.compactMap{ $0 as? UITextField }.forEach { textField in
            // bg colors
            textField.backgroundColor = .white
            
            // corner radius
            textField.layer.cornerRadius = 24
            
            // borders
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(named: "BorderGreyColor")?.cgColor
            textField.clipsToBounds = true
        }
        
        // Buttons
        backButton.tintColor = UIColor(named: "AppBlackColor")
    }
    
    /// sets the textual contents for the different parts
    func setContent() {
        // textual contents
        headerLabel.text = sharedLocalisationManager.localization.personalInfoScreen.header
        subHeaderLabel.text = sharedLocalisationManager.localization.personalInfoScreen.subHeader
        continueButton.setTitle(sharedLocalisationManager.localization.buttonTitles.buttonTitlesContinue, for: .normal)
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
        // Correct view alignment
        view.semanticContentAttribute = viewAlignment
    }
}
