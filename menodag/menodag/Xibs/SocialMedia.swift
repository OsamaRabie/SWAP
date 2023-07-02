//
//  SocialMedia.swift
//  menodag
//
//  Created by Osama Rabie on 27/06/2023.
//

import UIKit
import ViewAnimator

/// A protofocl to listen to events fired from the social media view
protocol SocialMediaDelegate {
    /// WIll be called when the user edits the social media handler attached in the view
    func socialMediaHandlerChanged(for socialMediaType:SocialMediaType, and value:String)
}

class SocialMedia: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var socialMediaHandlerTextField: UITextField!
    @IBOutlet weak var socialMediaNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    var socialMediaType:SocialMediaType = .Facebook
    var delegate:SocialMediaDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        setXib()
        setTheme()
        setDelegates()
    }
    
    func setXib() {
        Bundle.main.loadNibNamed("SocialMedia", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setTheme() {
        
        contentView.backgroundColor = UIColor(named: "SocialBackgroundColor") ?? .black
        contentView.layer.cornerRadius = 24
        //contentView.layer.borderColor = UIColor(named: "ShadowColor")?.cgColor ?? UIColor.black.cgColor
        //contentView.layer.borderWidth = 1
        //contentView.clipsToBounds = true
        contentView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor ?? UIColor.black.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 7
        contentView.layer.shadowOffset = .init(width: 0, height: 3 )
        
        socialMediaHandlerTextField.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        // set the font color
        socialMediaHandlerTextField.textColor = UIColor(named: "TextFieldsFontColor") ?? .black
        socialMediaHandlerTextField.attributedPlaceholder = NSAttributedString(string:"@Handler", attributes:[.foregroundColor: UIColor(named: "TextFieldPlacedHolderColor") ?? .black ,.font : MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)])
        
        // bg colors
        socialMediaHandlerTextField.backgroundColor = .white
        
        // corner radius
        socialMediaHandlerTextField.layer.cornerRadius = 15
        
        // borders
        socialMediaHandlerTextField.layer.borderWidth = 1
        socialMediaHandlerTextField.layer.borderColor = UIColor(named: "BorderGreyColor")?.cgColor
        socialMediaHandlerTextField.clipsToBounds = true
    }
    
    
    func setSocialMediaType(to type:SocialMediaType) {
        self.socialMediaType = type
        iconImageView.image = UIImage(named: type.imageName())
        socialMediaNameLabel.text = type.socialMediaName()
        
        let animation = AnimationType.from(direction: .top, offset: 30.0)
        socialMediaNameLabel.animate(animations: [animation])
    }
    
    
    func setDelegates() {
        socialMediaHandlerTextField.delegate = self
    }
    
}


//MARK: - TextField delegate
extension SocialMedia:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // let us get the new text entered by the user
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let textAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        delegate?.socialMediaHandlerChanged(for: socialMediaType, and: textAfterUpdate)
        
        return true
    }
}



enum SocialMediaType:CaseIterable {
    case Facebook
    case Linkedin
    case Github
    case Twitter
    case Dribble
    
    func imageName() -> String {
        switch self {
            
        case .Facebook:
            return "Facebook"
        case .Linkedin:
            return "Linkedin"
        case .Github:
            return "Github"
        case .Twitter:
            return "Twitter"
        case .Dribble:
            return "Dribble"
        }
    }
    
    func socialMediaName() -> String {
        switch self {
            
        case .Facebook:
            return "Facebook"
        case .Linkedin:
            return "Linkedin"
        case .Github:
            return "Github"
        case .Twitter:
            return "Twitter"
        case .Dribble:
            return "Dribble"
        }
    }
    
    
    func socialMediaField() -> UserCardField {
        switch self {
            
        case .Facebook:
            return .faceBook
        case .Linkedin:
            return .linkedIn
        case .Github:
            return .gitHub
        case .Twitter:
            return .twitter
        case .Dribble:
            return .dribble
        }
    }
}
