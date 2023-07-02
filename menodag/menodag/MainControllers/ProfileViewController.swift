//
//  ProfileViewController.swift
//  menodag
//
//  Created by Osama Rabie on 30/06/2023.
//

import UIKit
import Hero
import SSSpinnerButton
import Longinus
import ViewAnimator
import ContactsUI
import MessageUI

class ProfileViewController: UIViewController {

    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var myLinksLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contactButton: SSSpinnerButton!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var card:Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeroIDs()
        self.hero.isEnabled = true
        processLocalisationFontsAligments()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.animate()
        }
    }
    
    /// Will set the ids for the diferent uiviews to prepare them for the hero animation while navigation to other screens
    func setHeroIDs() {
        
    }
    
    
    /// Responsible for setting the correct content localistion, localised fonts & language based directions
    func processLocalisationFontsAligments() {
        setFonts()
        setTheme()
        setContent()
        //setDirections()
        //setDelegates()
    }
    
    func animate() {
        //holderView.animate(animations: [AnimationType.zoom(scale: 0.8)])
        
        UIView.animate(views: [holderView ], animations: [AnimationType.zoom(scale: 0.7)]) {
            self.profileImageView.animate(animations: [AnimationType.from(direction: .top, offset: 65)])
        }
    }
}


//MARK: - Theme based functions
extension ProfileViewController {
    
    /// setting the fonts for all the related sub views
    func setFonts() {
        // Labels
        nameLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 26)
        jobLabel.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        myLinksLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 18)
        // Buttons
        contactButton.titleLabel?.font = MenodagFont.localizedFont(for: .PoppinsMedium, with: 18)
    }
    
    /// Adjust the theme needed values
    func setTheme() {
        // profile image view
        profileImageView.layer.cornerRadius = 65
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor(named: "SocialBackgroundColor")?.cgColor ?? UIColor.white.cgColor
        
        // holder view
        holderView.clipsToBounds = true
        holderView.layer.cornerRadius = 36
        holderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
    }
    
    /// sets the textual contents for the different parts
    func setContent() {
        nameLabel.text = "\(card?.personalData?.fistName ?? "") \(card?.personalData?.lastName ?? "")"
        jobLabel.text = card?.professionalData?.title
        
        if let url = URL(string: card?.personalData?.photo ?? "") {
            profileImageView.lg.setImage(with: url, options: [.progressiveBlur, .imageWithFadeAnimation])
        }else{
            profileImageView.image = .init(systemName: "person.circle")?.withTintColor(.init(named: "AppGreyColor") ?? .gray, renderingMode: .alwaysOriginal)
        }
    }
}

//MARK: - Storyboard events
extension ProfileViewController {
    @IBAction func backArrowClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func connectClicked(_ sender: Any) {
        contactButton.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor(named: "ActionButtonTitleColor") ?? .black, spinnerSize: 20, complete: {
            // Your code here
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.contactButton.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true) {
                    let alert:UIAlertController = .init(title: sharedLocalisationManager.localization.connectAlert.title, message: String(format: sharedLocalisationManager.localization.connectAlert.subTitle, self.card?.personalData?.fistName ?? ""), preferredStyle: .alert)
                    alert.addAction(.init(title: sharedLocalisationManager.localization.buttonTitles.ok, style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        })
    }
    
    @IBAction func callClicked(_ sender: Any) {
        guard let phoneNumber:String = card?.contactData?.phone else { return }
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func mailClicked(_ sender: Any) {
        let alert:UIAlertController = .init(title: sharedLocalisationManager.localization.smsMailPicker.title, message: sharedLocalisationManager.localization.smsMailPicker.subTitle, preferredStyle: .actionSheet)
        let smsAction:UIAlertAction = .init(title: sharedLocalisationManager.localization.smsMailPicker.sms, style: .default) { _ in
            guard let phoneNumber:String = self.card?.contactData?.phone else { return }
            
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Hello i'm \(SwapFirebaseUsers.currentUserCard?.personalData?.fistName ?? "") from Swap"
                controller.recipients = [phoneNumber]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true)
            }
            
        }
        let emailAction:UIAlertAction = .init(title: sharedLocalisationManager.localization.smsMailPicker.email, style: .default) { _ in
            if MFMailComposeViewController.canSendMail() {
                guard let email:String = self.card?.contactData?.email else { return }
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([email])
                mail.setMessageBody("<p>Hello i'm \(SwapFirebaseUsers.currentUserCard?.personalData?.fistName ?? "") from Swap</p>", isHTML: true)
                
                self.present(mail, animated: true)
            } else {
                // show failure alert
            }
        }
        let cancelAction:UIAlertAction = .init(title: sharedLocalisationManager.localization.buttonTitles.cancel, style: .cancel)
        alert.addAction(smsAction)
        alert.addAction(emailAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        guard let card = card else { return }
        let contact = card.toContact(imageData: profileImageView.image?.jpeg(.high))
        
        let saveContactVC = CNContactViewController(forNewContact: contact)
        
        saveContactVC.contactStore = CNContactStore()
        saveContactVC.delegate = self
        saveContactVC.allowsActions = false
        
        let navigationController = UINavigationController(rootViewController: saveContactVC)
        present(navigationController, animated: false)
    }
}


//MARK: - CNContactViewControllerDelegate MFMessageComposeViewControllerDelegate
extension ProfileViewController: CNContactViewControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


//
