//
//  BusinessInfoViewController.swift
//  menodag
//
//  Created by Osama Rabie on 27/06/2023.
//

import UIKit
import SSSpinnerButton
import MOLH
import InitialsImageView
import Hero
import YPImagePicker
import Longinus

class BusinessInfoViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: SSSpinnerButton!
    @IBOutlet weak var profilaImageView: UIImageView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet var toBeLocalizedViews: [UIView]!
    @IBOutlet weak var parentStackView: UIStackView!
    var socialMediaViews:[SocialMedia] = []
    @IBOutlet weak var profileImageHolderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSocialMediaViews()
        setHeroIDs()
        self.hero.isEnabled = true
        processLocalisationFontsAligments()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){
            self.updateContinueButton()
        }
    }
    
    /// Adds the different views for different social media networks
    func addSocialMediaViews() {
        // First check if we created the views or not first
        guard socialMediaViews.isEmpty else { return }
        SocialMediaType.allCases.forEach({ socialMediaType in
            let socialMediaView:SocialMedia = .init(frame: .init(x: 0, y: 0, width: parentStackView.bounds.width, height: 76))
            socialMediaView.delegate = self
            socialMediaView.setSocialMediaType(to: socialMediaType)
            self.socialMediaViews.append(socialMediaView)
        })
        
        // Add some leading and trailing margins
        parentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        parentStackView.isLayoutMarginsRelativeArrangement = true
        
        // Now time to add them to the UI
        socialMediaViews.forEach { socialMediaView in
            socialMediaView.translatesAutoresizingMaskIntoConstraints = false
            let const = NSLayoutConstraint(item: socialMediaView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 76)
            const.priority = .defaultHigh
            const.isActive = true
            self.parentStackView.addArrangedSubview(socialMediaView)
        }
    }
    
    /// Responsible for setting the correct content localistion, localised fonts & language based directions
    func processLocalisationFontsAligments() {
        setFonts()
        setTheme()
        setContent()
        setDirections()
        setDelegates()
    }

    
    /// Will set the ids for the diferent uiviews to prepare them for the hero animation while navigation to other screens
    func setHeroIDs() {
        continueButton.hero.id = HeroIDsConstants.actionButton.rawValue
        jobTextField.hero.id = HeroIDsConstants.firstNameTextField.rawValue
        companyTextField.hero.id = HeroIDsConstants.lastNameTextField.rawValue
        headerLabel.hero.id = HeroIDsConstants.headerLabel.rawValue
    }
    
    /// Will assign self as a delegate for every needed component
    func setDelegates() {
        jobTextField.delegate = self
        companyTextField.delegate = self
    }
    
    
    /// Will enable/disable the continue button based on the validity of the data inside the card :)
    func updateContinueButton() {
        
        // Let us see how valid the current card user is
        let (validContact, personalContact, professionContact) = SwapFirebaseUsers.currentUserHasValidData()
        // Define animation attributes
        var finalAlpha = 1.0
        var zoomScale = 1.0
        var isEnabled = true
        // We will disable and fade out and shrink the button if the current card user cannot proceed as he didn't enter valid data
        if !(validContact && personalContact && professionContact) {
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
        if textField == jobTextField {
            return .title
        }else{
            return .company
        }
    }
}

//MARK: action handlers
extension BusinessInfoViewController {
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func imagePickerClicked(_ sender: Any) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto,
               let compressedImage:UIImage = photo.image.compressTo(0.33) {
                self.profilaImageView.image = compressedImage
                SwapFirebaseUsers.upload(image: compressedImage) { imageURL in
                    SwapFirebaseUsers.currentUserCard!.updateCurrentUserCard(for: .photo, with: imageURL)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        // let us load :)
        continueButton.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor(named: "ActionButtonTitleColor") ?? .black, spinnerSize: 20, complete: {
            // Your code here
            SwapFirebaseUsers.storeUpdateCurrentUser { card in
                // Move to the main page now :)
                DispatchQueue.main.async {
                    let homePageViewController:HomePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                    self.navigationController?.pushViewController(homePageViewController, animated: true)
                }
            } onError: { error in
                // End loading and then show an error
                self.continueButton.stopAnimate {
                    self.view.showError(title: error)
                }
            }
        })
    }
}

//MARK: Theme based methods
extension BusinessInfoViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setTheme()
        setFonts()
    }
    
    /// setting the fonts for all the related sub views
    func setFonts() {
        // Labels
        headerLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 32)
        // TextFields
        toBeLocalizedViews.compactMap{ $0 as? UITextField }.forEach { textField in
            // set the font
            textField.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
            // set the font color
            textField.textColor = UIColor(named: "TextFieldsFontColor") ?? .black
            // decide the placeholder
            var placeHolderText:String = ""
            if textField == jobTextField {
                placeHolderText = sharedLocalisationManager.localization.textFieldPlaceHolders.job
            }else if textField == companyTextField {
                placeHolderText = sharedLocalisationManager.localization.textFieldPlaceHolders.company
            }
            textField.attributedPlaceholder = NSAttributedString(string:placeHolderText, attributes:[.foregroundColor: UIColor(named: "TextFieldPlacedHolderColor") ?? .black ,.font : MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)])
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
        
        // Views
        profileImageHolderView.layer.cornerRadius = 32
        profileImageHolderView.clipsToBounds = true
        profileImageHolderView.layer.borderWidth = 3
        profileImageHolderView.layer.borderColor = (UIColor(named: "ShadowColor") ?? .black).cgColor
    }
    
    /// sets the textual contents for the different parts
    func setContent() {
        // textual contents
        headerLabel.text    = sharedLocalisationManager.localization.personalInfoScreen.header
        // buttons
        continueButton.setTitle(sharedLocalisationManager.localization.buttonTitles.buttonTitlesContinue, for: .normal)
        backButton.setTitle("", for: .normal)

        
        // Fill in the ProfessionalData if any
        if let contactData:ProfessionalData  = SwapFirebaseUsers.currentUserCard?.professionalData {
            jobTextField.text       = contactData.title
            companyTextField.text   = contactData.company
            socialMediaViews.forEach { socialMedia in
                socialMedia.socialMediaHandlerTextField.text = SwapFirebaseUsers.currentUserCard?.valueFor(socialMediaType:socialMedia.socialMediaType)
            }
            
            if let url = URL(string:SwapFirebaseUsers.currentUserCard?.personalData?.photo ?? "") {
                profilaImageView.lg.setImage(with: url, options: [.progressiveBlur, .imageWithFadeAnimation])
            }
        }
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
extension BusinessInfoViewController: UITextFieldDelegate {
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


//MARK: - Social media delegate
extension BusinessInfoViewController: SocialMediaDelegate {
    func socialMediaHandlerChanged(for socialMediaType: SocialMediaType, and value: String) {
        SwapFirebaseUsers.currentUserCard!.updateCurrentUserCard(for: socialMediaType.socialMediaField(), with: value)
    }
}
