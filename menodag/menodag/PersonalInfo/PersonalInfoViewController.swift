//
//  PersonalInfoViewController.swift
//  menodag
//
//  Created by Osama Rabie on 23/06/2023.
//

import UIKit
import SSSpinnerButton
import MOLH
import Hero
import ViewAnimator

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
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet var toBeLocalizedViews: [UIView]!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeroIDs()
        self.hero.isEnabled = true
        processLocalisationFontsAligments()
        assignDelegates()
        reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){
            self.updateContinueButton()
        }
    }
    
    /// Will fill in the data from the card into the proper text fields
    func reloadData() {
        // Make sure we have a valid user card data to fetch some data from it
        guard let nonNullCurrentUser:Card = SwapFirebaseUsers.currentUserCard else { return }
        
        // Fill in the contact data
        if let contactData:ContactData  = nonNullCurrentUser.contactData {
            emailAddressTextField.text  = contactData.email
            phoneNumberTextField.text   = contactData.phone
            // These fields will not be editable
            if !contactData.email.isEmpty { emailAddressTextField.isEnabled  = false }
            if !contactData.phone.isEmpty { phoneNumberTextField.isEnabled   = false }
        }
        
        // Fill in the personal data
        if let personalData:PersonalData = nonNullCurrentUser.personalData {
            firstNameTextField.text = personalData.fistName
            lastNameTextField.text  = personalData.lastName
            userNameTextField.text  = personalData.userName
        }
        
        // If he is logged already, we need to show the delete account button
        if let _ = SwapKeyChain.firebaseKeyForLoggedInUser() {
            deleteAccountButton.isHidden = false
            footerLabel.isHidden = true
        }else{
            deleteAccountButton.isHidden = true
            footerLabel.isHidden = false
        }
    }
    
    /// Responsible for setting the correct content localistion, localised fonts & language based directions
    func processLocalisationFontsAligments() {
        setFonts()
        setTheme()
        setContent()
        setDirections()
    }
    
    /// Will set the ids for the diferent uiviews to prepare them for the hero animation while navigation to other screens
    func setHeroIDs() {
        continueButton.hero.id = HeroIDsConstants.actionButton.rawValue
        phoneNumberTextField.hero.id = HeroIDsConstants.phoneTextField.rawValue
        headerLabel.hero.id = HeroIDsConstants.headerLabel.rawValue
        subHeaderLabel.hero.id = HeroIDsConstants.subHeaderLabel.rawValue
        firstNameTextField.hero.id = HeroIDsConstants.firstNameTextField.rawValue
        lastNameTextField.hero.id = HeroIDsConstants.lastNameTextField.rawValue
    }
    
    /// Will assign textfield delegate to all the text fiels to self
    func assignDelegates() {
        toBeLocalizedViews.compactMap{ $0 as? UITextField }.forEach{ $0.delegate = self }
    }
    
    /// Will enable/disable the continue button based on the validity of the data inside the card :)
    func updateContinueButton() {
        
        // Let us see how valid the current card user is
        let (validContact, personalContact, _) = SwapFirebaseUsers.currentUserHasValidData()
        // Define animation attributes
        var finalAlpha = 1.0
        var zoomScale = 1.0
        var isEnabled = true
        // We will disable and fade out and shrink the button if the current card user cannot proceed as he didn't enter valid data
        if !(validContact && personalContact) {
            finalAlpha = 0.7
            zoomScale = 0.8
            isEnabled = false
        }
        
        // let us apply the animation now
        // We will only apply the animation if the button is not already in the final stage we want to achieve
        guard continueButton.isEnabled != isEnabled else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
            self.continueButton.transform = CGAffineTransform.identity.scaledBy(x: zoomScale, y: zoomScale)
            self.continueButton.alpha = finalAlpha
        })
        continueButton.isEnabled = isEnabled
    }
    
    
    /// Decides each text field is connected to which field inside the card
    /// - Parameter textField: The textfield that we want to connect
    /// - Returns: The UserCardField we want to connect to the textfield
    func textFieldToCardField(textField:UITextField) -> UserCardField {
        if textField == firstNameTextField {
            return .firstName
        }else if textField == lastNameTextField {
            return .lastName
        }else if textField == phoneNumberTextField {
            return .phone
        }else if textField == emailAddressTextField {
            return .emailAddress
        }else{
            return .userName
        }
    }
}

//MARK: action handlers
extension PersonalInfoViewController {
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        let alert:UIAlertController = .init(title: "Delete the account?", message: "Do you want to delete your account from our network?", preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Delete", style: .destructive,handler: { _ in
            SwapFirebaseUsers.deleteUser {
                self.navigationController?.popViewController(animated: true)
            } onError: { error in
                self.view.showError(title: error)
            }

        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        let businessInfoViewController:BusinessInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "BusinessInfoViewController") as! BusinessInfoViewController
        self.navigationController?.pushViewController(businessInfoViewController, animated: true)
    }
}



//MARK: Theme based methods
extension PersonalInfoViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setTheme()
        setFonts()
    }
    
    /// setting the fonts for all the related sub views
    func setFonts() {
        // Labels
        headerLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 32)
        subHeaderLabel.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        footerLabel.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
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
            textField.attributedPlaceholder = NSAttributedString(string:placeHolderText, attributes:[.foregroundColor: UIColor(named: "TextFieldPlacedHolderColor") ?? .black ,.font : MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)])
        }
        
        // Buttons
        continueButton.titleLabel?.font = MenodagFont.localizedFont(for: .PoppinsMedium, with: 18)
        deleteAccountButton.titleLabel?.font = MenodagFont.localizedFont(for: .PoppinsLight, with: 14)
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
        headerLabel.text    = sharedLocalisationManager.localization.personalInfoScreen.header
        subHeaderLabel.text = sharedLocalisationManager.localization.personalInfoScreen.subHeader
        footerLabel.text    = sharedLocalisationManager.localization.personalInfoScreen.footer
        // buttons
        continueButton.setTitle(sharedLocalisationManager.localization.buttonTitles.buttonTitlesContinue, for: .normal)
        deleteAccountButton.setTitle(sharedLocalisationManager.localization.buttonTitles.delete, for: .normal)
        backButton.setTitle("", for: .normal)
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


//MARK: TextField delegate
extension PersonalInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // let us get the new text entered by the user
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let textAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        // Let us update the current user card with the newely provided data
        SwapFirebaseUsers.currentUserCard!.updateCurrentUserCard(for: textFieldToCardField(textField: textField), with: textAfterUpdate)
        // Let us revalidate and check if he can go through the next step
        updateContinueButton()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // let us see if we need to show an error message after editing this text field
        let (isValid,errorMessage) = Card.validate(field: textFieldToCardField(textField: textField), value: textField.text)
        if !isValid {
            self.view.showError(title: errorMessage)
        }
    }
}
