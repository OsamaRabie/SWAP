//
//  SearchResultsViewController.swift
//  menodag
//
//  Created by Osama Rabie on 02/07/2023.
//

import UIKit
import Hero
import ViewAnimator
import MOLH

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var emptyTableView: EmptyTableView!
    
    var menodagData:[Card] = []
    
    var dataSource:[Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setHeroIDs()
        self.hero.isEnabled = true
        processLocalisationFontsAligments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTable()
        storeHistory()
    }
    
    /// WIll save the search results to appear again in the recent
    func storeHistory() {
        // let us get the current stored array
        var cards:[Card] = SwapKeyChain.getStoredCards()
        cards.append(contentsOf: dataSource)
        SwapKeyChain.store(cards: Array(cards.removeDuplicates().prefix(100)))
    }
    
    /// Will set the ids for the diferent uiviews to prepare them for the hero animation while navigation to other screens
    func setHeroIDs() {
        //shareButton.hero.id     = HeroIDsConstants.actionButton.rawValue
        headerLabel.hero.id     = HeroIDsConstants.headerLabel.rawValue
    }
    
    /// Responsible for setting the correct content localistion, localised fonts & language based directions
    func processLocalisationFontsAligments() {
        setFonts()
        setTheme()
        setContent()
        setDirections()
        setDelegates()
    }
    
    /// Call it to update the table view with new data
    func updateTable() {
        resultsTableView.reloadData()
        if dataSource.isEmpty {
            resultsTableView.isHidden = false
            emptyTableView.setup(with: .SearchHistory)
            emptyTableView.isHidden = false
        }else{
            emptyTableView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){
                self.resultsTableView.isHidden = false
                let cells2 = self.resultsTableView.visibleCells(in: 1)
                UIView.animate(views: cells2, animations: [AnimationType.zoom(scale: 0.3), AnimationType.from(direction: .top, offset: 30)])
            }
        }
    }
}



//MARK: - Theme based methods
extension SearchResultsViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setTheme()
        setFonts()
    }
    
    /// setting the fonts for all the related sub views
    func setFonts() {
        // Labels
        headerLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 32)
    }
    
    /// Adjust the theme needed values
    func setTheme() {
        
    }
    
    func setContent() {
        // The table view
        resultsTableView.register(UINib(nibName: "UserCardTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCardTableViewCell")
        
    }
    
    func setDirections() {
        // Correct view aligment
        let viewAlignment:UISemanticContentAttribute = MOLHLanguage.isArabic() ? .forceRightToLeft : .forceLeftToRight
        // Correct view alignment
        view.semanticContentAttribute = viewAlignment
    }
    
    func setDelegates() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }
    
    
    func handleSelection(of card:Card) {
        if let urlString:String = card.contactData?.url,
           let url:URL = .init(string: urlString) {
            UIApplication.shared.open(url)
        }else{
            let profileViewController:ProfileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profileViewController.card = card
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
}



//MARK: - Table view related methods
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? menodagData.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell:UserCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserCardTableViewCell", for: indexPath) as! UserCardTableViewCell
        userCell.setup(with: indexPath.section == 0 ? menodagData[indexPath.row] : dataSource[indexPath.row])
        return userCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleSelection(of: indexPath.section == 0 ? menodagData[indexPath.row] : dataSource[indexPath.row])
    }
}




//MARK: action handlers
extension SearchResultsViewController {
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
