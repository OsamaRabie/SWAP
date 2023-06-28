//
//  ViewController.swift
//  menodag
//
//  Created by Osama Rabie on 13/05/2023.
//

import UIKit
import MOLH
import AuthenticationServices
import FirebaseAuth
import FirebaseDatabase
import BJOTPViewController
import SSSpinnerButton
import AuthenticationServices
import Hero
import Toast

class ViewController: UIViewController {

    //MARK: Auth variables
    /// The verification id firebase shares to validate the OTP against
    var firebasePhoneVerificationID:String? = ""
    /// The OTP view to collect OTP from the user
    var otpScreen: BJOTPViewController?
    //MARK: IBOutlets
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var subHeaderTitleLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet var toBeLocalizedViews: [UIView]!
    @IBOutlet weak var currentLanguageImageView: UIImageView!
    @IBOutlet weak var continueButton: SSSpinnerButton!
    @IBOutlet weak var termsConditionsLabel: UILabel!
    @IBOutlet weak var orContinueWithLabel: UILabel!
    
    /// Reference to the app users database
    let userDatabaseReference: DatabaseReference = Database.database(url: "https://menodag-b32f3-4303d.firebaseio.com/").reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        processLocalisationFontsAligments()
        setHeroIDs()
        self.navigationController?.hero.isEnabled = true
        self.hero.isEnabled = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // defensive coding, let us reset the current card data
        SwapFirebaseUsers.currentUserCard = nil
    }
    
    /// Will set the ids for the diferent uiviews to prepare them for the hero animation while navigation to other screens
    func setHeroIDs() {
        continueButton.hero.id = HeroIDsConstants.actionButton.rawValue
        phoneTextField.hero.id = HeroIDsConstants.phoneTextField.rawValue
        headerTitleLabel.hero.id = HeroIDsConstants.headerLabel.rawValue
        subHeaderTitleLabel.hero.id = HeroIDsConstants.subHeaderLabel.rawValue
    }
    
    /// Responsible for setting the correct content localistion, localised fonts & language based directions
    func processLocalisationFontsAligments() {
        setFonts()
        setTheme()
        setContent()
        setDirections()
        setDelegates()
        updateContinueButton()
    }
}

//MARK: Theme based methods
extension ViewController {
    /// setting the fonts for all the related sub views
    func setFonts() {
        // Labels
        headerTitleLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 32)
        subHeaderTitleLabel.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        continueButton.titleLabel?.font = MenodagFont.localizedFont(for: .PoppinsMedium, with: 18)
        termsConditionsLabel.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        orContinueWithLabel.font = MenodagFont.localizedFont(for: .PoppinsMedium, with: 14)
        
        
        // TextFields
        phoneTextField.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        phoneTextField.attributedPlaceholder = NSAttributedString(string:sharedLocalisationManager.localization.textFieldPlaceHolders.phone, attributes:[.foregroundColor: UIColor(named: "TextFieldPlacedHolderColor") ?? .black ,.font : MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)])
        phoneTextField.textColor = UIColor(named: "TextFieldsFontColor") ?? .black
        // Buttons
        forgotPasswordButton.titleLabel?.font = MenodagFont.localizedFont(for: .PoppinsMedium, with: 14)
        
    }
    
    /// Adjust the theme needed values
    func setTheme() {
        // bg colors
        phoneTextField.backgroundColor = .white
        
        // corner radius
        phoneTextField.layer.cornerRadius = 24
        
        // borders
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor(named: "BorderGreyColor")?.cgColor
        phoneTextField.clipsToBounds = true
    }
    
    /// sets the textual contents for the different parts
    func setContent() {
        // textual contents
        headerTitleLabel.text = sharedLocalisationManager.localization.getStarted.header
        subHeaderTitleLabel.text = sharedLocalisationManager.localization.getStarted.subHeader
        forgotPasswordButton.setTitle(sharedLocalisationManager.localization.getStarted.forgorPassword, for: .normal)
        continueButton.setTitle(sharedLocalisationManager.localization.buttonTitles.buttonTitlesContinue, for: .normal)
        termsConditionsLabel.text = sharedLocalisationManager.localization.getStarted.termsConditions
        orContinueWithLabel.text = sharedLocalisationManager.localization.getStarted.orContinueWith
        
        // Image view contents
        currentLanguageImageView.image = UIImage(named: MOLHLanguage.isArabic() ? "kuwait" : "usa")
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
    
    /// Sets self as a delegate to the correct views
    func setDelegates() {
        phoneTextField.delegate = self
    }
    
    /// Will enable/disable the continue button based on the validity of the data inside the card :)
    func updateContinueButton(with phone:String = "") {
        // Let us see how valid the current card user is
        let (isValid, errorMessage) = Card.validate(field: .phone, value: phone)
        // Define animation attributes
        var finalAlpha = 1.0
        var zoomScale = 1.0
        var isEnabled = true
        // We will disable and fade out and shrink the button if the current card user cannot proceed as he didn't enter valid data
        if !isValid {
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
}


//MARK: Storyboard actions
extension ViewController {
    
    /// Will show the language picker
    @IBAction private func changeLanguageClicked(_ sender: Any) {
        
        let languageSheet:UIAlertController = .init(title: sharedLocalisationManager.localization.languagePicker.title, message: sharedLocalisationManager.localization.languagePicker.subTitle, preferredStyle: .actionSheet)
        
        let arabic:UIAlertAction = .init(title: sharedLocalisationManager.localization.languagePicker.arabic, style: .default) { _ in
            MOLH.setLanguageTo("ar")
            self.processLocalisationFontsAligments()
        }
        
        let english:UIAlertAction = .init(title: sharedLocalisationManager.localization.languagePicker.english, style: .default) { _ in
            MOLH.setLanguageTo("en")
            self.processLocalisationFontsAligments()
        }
        
        let cancel:UIAlertAction = .init(title: sharedLocalisationManager.localization.buttonTitles.cancel, style: .cancel)
        
        
        languageSheet.addAction(arabic)
        languageSheet.addAction(english)
        languageSheet.addAction(cancel)
        
        present(languageSheet, animated: true)
        
    }
    
    /// Handle signing in with Apple
    @IBAction private func signInWithPhoneClicked(_ sender: Any) {
        // Check if we have a valid phone
        guard let phone:String = phoneTextField.text,
              phone.isValidPhoneNumber() else {
            self.view.showError(title: "A problem occured, please try again later")
            return
        }
        continueButton.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor(named: "ActionButtonTitleColor") ?? .black, spinnerSize: 30, complete: {
            // Your code here
            self.sendOTP(to: phone)
        })
    }
    
    
    /// Handle signing in with Apple
    @IBAction private func signUpApplePayClicked(_ sender: Any) {
        continueButton.startAnimate(spinnerType: .circleStrokeSpin, spinnercolor: .init(named: "ActionButtonTitleColor") ?? .black, complete: {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        })
    }
}

//MARK: Firebase Phone Authentication
extension ViewController {
    /// Tells firebase to send an otp to the number
    /// - Parameter to: The phone number to send the otp to
    func sendOTP(to phoneNumber:String) {
        // Set the authentication localisation
        Auth.auth().languageCode = MOLHLanguage.isArabic() ? "ar" : "en"
        // Send the OTP
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                // Check if firebase didn't send back any issue/error
                if let _ = error {
                    self.continueButton.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                        // Your code here
                        self.view.showError(title: sharedLocalisationManager.localization.errors.signWithPhoneError)
                    })
                    return
                }
                // Store the verification id
                self.firebasePhoneVerificationID = verificationID
                // Collect the OTP
                self.collectOTP()
            }
    }
    
    /// Starts the OTP collecting process
    func collectOTP() {
        ///Initialize viewcontroller
        self.otpScreen = BJOTPViewController(withHeading: sharedLocalisationManager.localization.otpScreen.header,
                                             withNumberOfCharacters: 6,
                                             delegate: self)
        
        ///Configuration
        configureOTPScreen(otpScreen)
        
        ///Present view controller modally
        present(self.otpScreen!, animated: true)
    }
    
    /// Will verify the entered OTP by the customer with firebase
    /// - Parameter otp: The string the user did enter and we need to verify
    func verify(otp:String) {
        // Create a FIRPhoneAuthCredential object from the verification code and verification ID.
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: self.firebasePhoneVerificationID ?? "",
            verificationCode: otp
        )
        
        // Sign in the user with the FIRPhoneAuthCredential object:
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("USER PHONE : \(error)")
            }else if let authResult = authResult {
                print("USER PHONE : \(authResult.user.phoneNumber ?? "UNKNOWN")")
            }else{
                print("NO DATA")
            }
        }
    }
}


/**
 * Making view controller conform to `BJOTPViewControllerDelegate` protocol.
 *
 * These delegate methods are key to handling the entered otp string
 * and other events in the view controller.
 */
extension ViewController: BJOTPViewControllerDelegate {
    
    /// Configures the UI/UX of the OTP screen
    /// - Parameter otpScreen: The otp view we will use to get the OTP from the user
    func configureOTPScreen(_ otpScreen: BJOTPViewController?) {
        
        guard let otpScreen = otpScreen else { return }
        
        let primaryLabel: String = sharedLocalisationManager.localization.otpScreen.title
        let secondaryLabel: String = sharedLocalisationManager.localization.otpScreen.message
        let buttonTitle: String = sharedLocalisationManager.localization.otpScreen.actionButton
        
        //Set titles and options
        otpScreen.authenticateButtonColor = .init(named: "ActionButtonBGColor")
        otpScreen.openKeyboadDuringStartup = true
        otpScreen.accentColor = [.systemRed, .systemBlue].randomElement()!
        otpScreen.primaryHeaderTitle = primaryLabel
        otpScreen.secondaryHeaderTitle = secondaryLabel
        otpScreen.footerTitle = sharedLocalisationManager.localization.otpScreen.resend
        otpScreen.shouldFooterBehaveAsButton = true
        otpScreen.authenticateButtonTitle = buttonTitle
        otpScreen.brandImage = .init(named: "SwapIcon")
        otpScreen.delegate = self
    }
    
    func didClose(_ viewController: BJOTPViewController) {
        ///option-click on the method name above to see more details about it.
        self.otpScreen = nil
        self.continueButton.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .none, backToDefaults: true, complete: nil)
    }
    
    func authenticate(_ otp: String, from viewController: BJOTPViewController) {
        ///option-click on the method name above to see more details about it.
        viewController.dismiss(animated: true) {
            self.verify(otp: otp)
        }
    }
    
    func didTap(footer button: UIButton, from viewController: BJOTPViewController) {
        ///option-click on the method name above to see more details about it.
    }
    
}


//MARK: Apple sign in Authentication
extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            // we need to fetch the email whether from JWT token or from the email raw value itself
            // worth noting, that email value is provided only 1st time. Then, you use JWT
            var email:String? = appleIDCredential.email
            
            if email == nil {
                // Hence, we need to try fetching it from the JWT token of any
                if let jwtToken = appleIDCredential.identityToken,
                   let identityTokenString: String = String(data: jwtToken, encoding: .utf8),
                   let jwt:JWT = try? decode(jwt: identityTokenString) {
                    
                    let decodedBody = jwt.body as Dictionary<String, Any>
                    email = decodedBody["email"] as? String
                }
            }
            
            guard let nonNullEmail:String = email else {
                // We didn't get the email with any means
                self.continueButton.stopAnimatingWithCompletionType(completionType: .fail) {
                    self.view.showError(title: sharedLocalisationManager.localization.errors.signWithPhoneError)
                }
                return
            }
            
            logInWith(email: nonNullEmail)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.view.showError(title: sharedLocalisationManager.localization.errors.signWithPhoneError)
    }
    
    /// Will do the logic needed to make sure if there is a user registered with this email, will be moved to the profile page
    /// Otherwise, it will take him to sign up page
    /// - Parameter email: The verified email you want to log the user with
    func logInWith(email:String) {
        // let us check if we have a registered user or not first
        SwapFirebaseUsers.fetchUser(email: email) { userCard in
            // This means the user is registered and has basic info added
        } onNotFound: {
            // This means the user is not registered, so we need him to fill in his data
            self.continueButton.stopAnimatingWithCompletionType(completionType: .none) {
                // let us create the user card and fill in the email
                SwapFirebaseUsers.currentUserCard = .init(contactData: .init(phone: nil, email: email), personalData: .init(), professionalData: .init())
                // let us move to the sign up process controller
                let personalInfoViewController:PersonalInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInfoViewController") as! PersonalInfoViewController
                self.navigationController?.pushViewController(personalInfoViewController, animated: true)
            }
        } onError: { error in
            // This means, an error occured and we need to tell the user about it
            self.continueButton.stopAnimatingWithCompletionType(completionType: .error) {
                self.view.showError(title: error)
            }
        }

    }
    
    func isAppleLoggedIn() {
        /*let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) {  (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                break
            case .revoked:
                // The Apple ID credential is revoked.
                break
            case .notFound:
                // No credential was found, so show the sign-in UI.
            default:
                break
            }
        }*/
    }
}




//MARK: TextField delegate
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // let us get the new text entered by the user
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let textAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        // Let us revalidate the phone entered and check if he can go through the next step
        updateContinueButton(with: textAfterUpdate)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let (isValid,errorMessage) = Card.validate(field: .phone, value: phoneTextField.text)
        if !isValid {
            self.view.showError(title: errorMessage)
        }
    }
}
