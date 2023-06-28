//
//  SocialMedia.swift
//  menodag
//
//  Created by Osama Rabie on 27/06/2023.
//

import UIKit

class SocialMedia: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var socialMediaHandlerTextField: UITextField!
    @IBOutlet weak var socialMediaNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    var socialMediaType:SocialMediaType = .Facebook
    
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
        contentView.layer.shadowColor =  UIColor(named: "ShadowColor")?.cgColor ?? UIColor.black.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 14
        contentView.layer.shadowOffset = .init(width: 0, height: 0 )
        
        
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
    }
    
}



enum SocialMediaType {
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
}
