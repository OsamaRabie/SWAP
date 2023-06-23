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
            self.view.showError(title: "❕", message: "A problem occured, please try again later", messageType: .Error)
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
        
        self.userDatabaseReference.child("users").child("osama").setValue(["username2": "OSAMA"])
        
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
                        self.view.showError(title: "❕", message: sharedLocalisationManager.localization.errors.signWithPhoneError, messageType: .Error)
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
                self.view.showError(title: "❌", message: sharedLocalisationManager.localization.errors.signWithPhoneError, messageType: .Error)
                return
            }
            
            // We have a valid email :)
            self.view.showError(title: "Signed in", message: "EMAIL IS :\(nonNullEmail)", messageType: .Message)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.view.showError(title: "❌", message: sharedLocalisationManager.localization.errors.signWithPhoneError, messageType: .Error)
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
