//
//  EmptyTableView.swift
//  menodag
//
//  Created by Osama Rabie on 30/06/2023.
//

import UIKit

class EmptyTableView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
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
        Bundle.main.loadNibNamed("EmptyTableView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setTheme() {
        titleLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 16)
        messageLabel.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        
        contentView.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor ?? UIColor.black.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 14
        contentView.layer.cornerRadius = 24
        contentView.layer.shadowOffset = .init(width: 0, height: 7 )
        
        imageView.tintColor = UIColor(named: "AppGreyColor") ?? UIColor.black
    }
    
    
    func setup(with emptyStateType:EmptyTableType) {
        let (image, title, message) = emptyStateType.stateData()
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setTheme()
    }
    
}


/// An enum to define the different states for empty table views
enum EmptyTableType {
    /// No search history
    case SearchHistory
    /// No exchange history
    case ExchangeHistory
    /// No product history
    case ProductHistory
    
    /// Sends back the image, title and subtitle based on the state
    func stateData() -> (image:UIImage, title:String, message:String) {
        switch self {
        case .SearchHistory: return (UIImage(systemName: "repeat.circle")!,
                                     sharedLocalisationManager.localization.emptyTable.searchHistoryLabel,
                                     sharedLocalisationManager.localization.emptyTable.searchHistoryMessage)
        case .ExchangeHistory: return (UIImage(systemName: "shareplay.slash")!,
                                     sharedLocalisationManager.localization.emptyTable.exchangeHistoryLabel,
                                     sharedLocalisationManager.localization.emptyTable.exchangeHistoryMessage)
        case .ProductHistory: return (UIImage(named: "NoNfCIcon")!.withTintColor(UIColor(named: "AppGreyColor") ?? .white),
                                       sharedLocalisationManager.localization.emptyTable.productHistoryLabel,
                                       sharedLocalisationManager.localization.emptyTable.productHistoryMessage)
        }
    }
}
