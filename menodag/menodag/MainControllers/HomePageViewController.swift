//
//  HomePageViewController.swift
//  menodag
//
//  Created by Osama Rabie on 28/06/2023.
//

import UIKit
import Hero
import MOLH
import HMSegmentedControl
import ViewAnimator

class HomePageViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet var toBeLocalizedViews: [UIView]!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var segmentController: HMSegmentedControl!
    @IBOutlet weak var emptyTableView: EmptyTableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var allData:[Card] = []
    var menodagData:[Card] = [] {
        didSet{
            updateTable()
        }
    }
    
    var dataSource:[Card] = [] {
        didSet{
            updateTable()
        }
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        setHeroIDs()
        self.hero.isEnabled = true
        processLocalisationFontsAligments()
        
        SwapFirebaseUsers.fetchAllMenoDagUsers { cards in
            self.menodagData = cards
            SwapFirebaseUsers.fetchAllUsers { cards in
                self.allData = cards
                self.dataSource = Array(self.allData.prefix(upTo: 10))
            } onError: { error in
                print(error)
            }
        } onError: { error in
            print(error)
        }

    }
    
    /// Will set the ids for the diferent uiviews to prepare them for the hero animation while navigation to other screens
    func setHeroIDs() {
        //shareButton.hero.id     = HeroIDsConstants.actionButton.rawValue
        headerLabel.hero.id     = HeroIDsConstants.headerLabel.rawValue
        searchTextField.hero.id = HeroIDsConstants.phoneTextField.rawValue
    }
    
    
    /// Will do a search on cards with the given keyword
    func performSearch(with keyword:String) {
        loading.isHidden = true
        if keyword.count > 3 {
            loading.isHidden = false
            // Check it is a number or a name search
            if keyword.isWholeNumber {
                // Search by phone
                SwapFirebaseUsers.fetchMatchingUsersBy(phone: keyword) { searchResults in
                    self.handleSearchResults(with: searchResults)
                    self.loading.isHidden = true
                } onError: { error in
                    print(error)
                    self.loading.isHidden = true
                }

            }else{
                // it is a name search
                SwapFirebaseUsers.fetchMatchingUsersBy(name: keyword) { searchResults in
                    self.handleSearchResults(with: searchResults)
                    self.loading.isHidden = true
                } onError: { error in
                    print(error)
                    self.loading.isHidden = true
                }
            }
        }else{
            self.view.showError(title: sharedLocalisationManager.localization.errors.userNameError)
        }
    }
    
    /// Will change the view of the table to show only the search results if any
    func handleSearchResults(with results:[Card]) {
        let searchResultsViewController:SearchResultsViewController = storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsViewController.menodagData = self.menodagData
        searchResultsViewController.dataSource = results
        self.navigationController?.pushViewController(searchResultsViewController, animated: true)
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
        let cells2 = resultsTableView.visibleCells(in: 1)
        UIView.animate(views: cells2, animations: [AnimationType.zoom(scale: 0.3)])
    }
}

//MARK: - Theme based methods
extension HomePageViewController {
    
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
        searchTextField.font = MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)
        searchTextField.attributedPlaceholder = NSAttributedString(string:sharedLocalisationManager.localization.textFieldPlaceHolders.search, attributes:[.foregroundColor: UIColor(named: "TextFieldPlacedHolderColor") ?? .black ,.font : MenodagFont.localizedFont(for: .PoppinsRegular, with: 14)])
        searchTextField.textColor = UIColor(named: "TextFieldsFontColor") ?? .black
    }
    
    /// Adjust the theme needed values
    func setTheme() {
        // bg colors
        searchTextField.backgroundColor = UIColor(named: "SearchTextFieldBackGroundColor")
        
        // corner radius
        searchTextField.layer.cornerRadius = 22
        searchTextField.clipsToBounds = true
        
        // TextField icon
        if let image = UIImage.init(systemName: "magnifyingglass")?.withTintColor(.init(named: "TextFieldPlacedHolderColor") ?? .gray, renderingMode: .alwaysOriginal) {
            searchTextField.setIcon(image: image, width: 16)
        }
        
        // Segment control
        segmentController.backgroundColor = .clear
        segmentController.type = .text
        segmentController.selectionIndicatorHeight = 1
        segmentController.selectionIndicatorLocation = .bottom
        segmentController.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TextFieldPlacedHolderColor") ?? .black , NSAttributedString.Key.font : MenodagFont.localizedFont(for: .PoppinsMedium, with: 17)]
        segmentController.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "AppBlackColor") ?? .black , NSAttributedString.Key.font : MenodagFont.localizedFont(for: .PoppinsBold, with: 18)]
        segmentController.segmentWidthStyle = .fixed
    }
    
    func setContent() {
        // The segment
        segmentController.sectionTitles = ["New", "History", "Exchanged"]
        // The table view
        resultsTableView.register(UINib(nibName: "UserCardTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCardTableViewCell")

    }
    
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
    
    func setDelegates() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        searchTextField.delegate = self
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
extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    
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



//MARK: - Story board actions
extension HomePageViewController {
    @IBAction func segmentTabChanged(_ sender: Any) {
        if segmentController.selectedSegmentIndex == 0 {
            dataSource = Array(allData.prefix(upTo: 5))
            resultsTableView.isHidden = false
            updateTable()
            emptyTableView.isHidden = true
        }else if segmentController.selectedSegmentIndex == 1{
            dataSource = SwapKeyChain.getStoredCards()
            emptyTableView.setup(with: .SearchHistory)
            if dataSource.isEmpty {
                resultsTableView.isHidden = true
                emptyTableView.isHidden = false
                let animation = AnimationType.from(direction: .top, offset: 30.0)
                emptyTableView.animate(animations: [animation])
            }else{
                resultsTableView.isHidden = false
                emptyTableView.isHidden = true
            }
        }else if segmentController.selectedSegmentIndex == 2{
            dataSource = []
            resultsTableView.isHidden = true
            resultsTableView.reloadData()
            emptyTableView.setup(with: .ExchangeHistory)
            emptyTableView.isHidden = false
            let animation = AnimationType.from(direction: .top, offset: 30.0)
            emptyTableView.animate(animations: [animation])
        }
    }
    
    
    @IBAction func productClicked(_ sender: Any) {
        // First check if he is logged in or not
        if let _ = SwapKeyChain.firebaseKeyForLoggedInUser() {
            let productsViewController:ProductsViewController = storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
            navigationController?.pushViewController(productsViewController, animated: true)
        }else{
            // Tell him he needs to create a profile first
            let alert:UIAlertController = .init(title: sharedLocalisationManager.localization.createProfileForCardAlert.title, message: sharedLocalisationManager.localization.createProfileForCardAlert.subTitle, preferredStyle: .alert)
            alert.addAction(.init(title: sharedLocalisationManager.localization.buttonTitles.ok, style: .cancel))
            present(alert, animated: true)
        }
    }
    
    
    
    @IBAction func profileClicked(_ sender: Any) {
        let personalInfoViewController:PersonalInfoViewController = storyboard?.instantiateViewController(withIdentifier: "PersonalInfoViewController") as! PersonalInfoViewController
        navigationController?.pushViewController(personalInfoViewController, animated: true)
    }
    
}


//MARK: - Textfield delegate methods
extension HomePageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch(with:textField.text ?? "")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //performSearch(with:textField.text ?? "")
    }
    
}
