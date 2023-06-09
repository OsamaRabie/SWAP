//
//  ViewController.swift
//  menodag
//
//  Created by Osama Rabie on 13/05/2023.
//

import UIKit
import MOLH
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import BJOTPViewController
import SSSpinnerButton

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        processLocalisationFontsAligments()
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
        phoneTextField.attributedPlaceholder = NSAttributedString(string:sharedLocalisationManager.localization.textFieldPlaceHolders.phone, attributes:[.foregroundColor: UIColor(named: "TextFieldsFontColor") ?? .black ,.font : MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)])
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
            self.view.showError(title: "❕", message: "A problem occured, please try again later")
            return
        }
        continueButton.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor(named: "ActionButtonTitleColor") ?? .black, spinnerSize: 30, complete: {
            // Your code here
            self.sendOTP(to: phone)
        })
    }
    
    
    /// Handle signing in with Apple
    @IBAction private func signUpApplePayClicked(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    
    /// Handle signing in with Google
    @IBAction private func signUpGoogleClicked(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard let result = signInResult else {
                // Inspect error
                return
            }
            // If sign in succeeded, display the app's main content View.
            let user = result.user
            
            let emailAddress = user.profile?.email
            
            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName
        }
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
                        self.view.showError(title: "❕", message: sharedLocalisationManager.localization.errors.signWithPhoneError)
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
        //Title
        let heading: String = "Two Factor Authentication"
        
        ///Initialize viewcontroller
        self.otpScreen = BJOTPViewController(withHeading: heading,
                                             withNumberOfCharacters: 6,
                                             delegate: self)
        
        ///Configuration
        configureOTPScreen(otpScreen)
        
        ///Present view controller modally
        present(self.otpScreen!, animated: true)
    }
    
    
    /// Configures the UI/UX of the OTP screen
    /// - Parameter otpScreen: The otp view we will use to get the OTP from the user
    func configureOTPScreen(_ otpScreen: BJOTPViewController?) {
        
        guard let otpScreen = otpScreen else { return }
        
        let imageName: String = ["logo.xbox", "logo.playstation"].randomElement()!
        let primaryLabel: String = "Enter One Time Code"
        let secondaryLabel: String = "A message with a verification code has been sent to your devices. Enter the code to continue."
        let buttonTitle: String = "LOGIN SECURELY"
        
        //Set titles and options
        otpScreen.openKeyboadDuringStartup = true
        otpScreen.accentColor = [.systemRed, .systemBlue].randomElement()!
        otpScreen.primaryHeaderTitle = primaryLabel
        otpScreen.secondaryHeaderTitle = secondaryLabel
        otpScreen.footerTitle = "Didn't get verification code?"
        otpScreen.shouldFooterBehaveAsButton = true
        otpScreen.authenticateButtonTitle = buttonTitle
        
        if #available(iOS 13.0, *) {
            otpScreen.brandImage = .init(systemName: imageName)?.withTintColor(UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black).withRenderingMode(.alwaysOriginal)
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
    
    func didClose(_ viewController: BJOTPViewController) {
        ///option-click on the method name above to see more details about it.
        self.otpScreen = nil
    }
    
    func authenticate(_ otp: String, from viewController: BJOTPViewController) {
        ///option-click on the method name above to see more details about it.
    }
    
    func didTap(footer button: UIButton, from viewController: BJOTPViewController) {
        ///option-click on the method name above to see more details about it.
    }
    
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
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



extension ViewController {
    
    func isGoogleLoggedIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
    }
}
