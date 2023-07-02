//
//  UserCardTableViewCell.swift
//  menodag
//
//  Created by Osama Rabie on 30/06/2023.
//

import UIKit
import MOLH
import Longinus

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var holdingView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet var toBeLocalizedViews: [UIView]!
    
    var attachedEvent:Event? {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        processLocalisationFontsAligments()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0))
    }
    
    /// Responsible for setting the correct content localistion, localised fonts & language based directions
    func processLocalisationFontsAligments() {
        setFonts()
        setTheme()
        setDirections()
    }
    
    func setup(with event:Event) {
        attachedEvent = event
    }
    
    func reloadData() {
        guard let event = attachedEvent else { return }
        
        nameLabel.text = event.title
        contactLabel.text = event.message
        dateLabel.text = "\(event.date ?? "")\n\(event.status ?? "")"
        
        avatarImageView.image = .init(systemName: event.image ?? "")?.withTintColor(.init(named: "AppGreyColor") ?? .gray, renderingMode: .alwaysOriginal)
        
        if event.status ?? "" != "progress" {
            contentView.alpha = 0.5
        }else{
            contentView.alpha = 1
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CardTableViewCell {
    /// setting the fonts for all the related sub views
    func setFonts() {
        // Labels
        nameLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 16)
        contactLabel.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 12)
    }
    
    /// Adjust the theme needed values
    func setTheme() {
        // bg color
        holdingView.backgroundColor = UIColor(named: "SocialBackgroundColor") ?? .systemBackground
        // corner radius
        holdingView.layer.cornerRadius = 24
        holdingView.clipsToBounds = true
        
        avatarImageView.layer.cornerRadius = 21
        avatarImageView.clipsToBounds = true
        
        // shadow
        contentView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor ?? UIColor.black.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 14
        contentView.layer.cornerRadius = 24
        contentView.layer.shadowOffset = .init(width: 0, height: 7 )
        
        selectionStyle = .none
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
        semanticContentAttribute = viewAlignment
        contentView.semanticContentAttribute = viewAlignment
    }
    
}
