//
//  ProductsViewController.swift
//  menodag
//
//  Created by Osama Rabie on 01/07/2023.
//

import UIKit
import SSSpinnerButton
import ViewAnimator
import Hero
class ProductsViewController: UIViewController {

    @IBOutlet weak var orderCardButton: SSSpinnerButton!
    @IBOutlet weak var emptyVuew: EmptyTableView!
    @IBOutlet weak var emptyHolderView: UIView!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    private let fireworkController = ClassicFireworkController()
    var dataSource:[Event] = [] {
        didSet {
            if dataSource != oldValue {
                reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeroIDs()
        self.hero.isEnabled = true
        processLocalisationFontsAligments()
        loadFromFirebase()
    }
    
    
    func loadFromFirebase() {
        SwapFirebaseUsers.fetchProduct { history in
            guard let history = history,
                  let events = history.events else { return }
            self.dataSource = events
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    
    /// Will set the ids for the diferent uiviews to prepare them for the hero animation while navigation to other screens
    func setHeroIDs() {
        headerLabel.hero.id = HeroIDsConstants.headerLabel.rawValue
    }
    
    
    /// Responsible for setting the correct content localistion, localised fonts & language based directions
    func processLocalisationFontsAligments() {
        setFonts()
        setTheme()
        setContent()
        //setDirections()
        setDelegates()
    }
    
    
    func animate() {
        if dataSource.isEmpty {
            resultsTableView.isHidden = true
            emptyHolderView.isHidden = false
            emptyHolderView.animate(animations: [AnimationType.zoom(scale: 0.5), AnimationType.from(direction: .top, offset: 50)])
        }else {
            resultsTableView.isHidden = false
            //emptyHolderView.isHidden = true
            emptyHolderView.animate(animations: [AnimationType.from(direction: .top, offset: -50)], initialAlpha: 1, finalAlpha: 0) {
                self.emptyHolderView.isHidden = true
            }
            let cells = resultsTableView.visibleCells(in: 0)
            UIView.animate(views: cells, animations: [AnimationType.zoom(scale: 0.5), AnimationType.from(direction: .top, offset: 10)])
        }
    }
    
    
    func reloadData() {
        resultsTableView.reloadData()
        animate()
    }
    
    
    func setDelegates() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




//MARK: - Theme based functions
extension ProductsViewController {
    
    /// setting the fonts for all the related sub views
    func setFonts() {
        // Labels
        headerLabel.font = MenodagFont.localizedFont(for: .PoppinsBold, with: 26)
        // Buttons
        orderCardButton.titleLabel?.font = MenodagFont.localizedFont(for: .PoppinsMedium, with: 18)
    }
    
    
    /// Adjust the theme needed values
    func setTheme() {
        
    }
    
    
    /// sets the textual contents for the different parts
    func setContent() {
        headerLabel.text = "My Products"
        emptyVuew.setup(with: .ProductHistory)
        resultsTableView.isHidden = true
        emptyHolderView.isHidden = true
        resultsTableView.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: "CardTableViewCell")
    }
}


//MARK: - Storyboard events
extension ProductsViewController {
    @IBAction func backArrowClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getProductClicked(_ sender: Any) {
        
        orderCardButton.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor(named: "ActionButtonTitleColor") ?? .black, spinnerSize: 20, complete: {
            // Your code here
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){
                self.orderCardButton.stopAnimatingWithCompletionType(completionType: .success) {
                    self.fireworkController.addFireworks(count: 10, sparks: 8, around: self.emptyHolderView)
                    
                    let productHistory:ProductHistory = ProductHistory.createDefaultCard()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){
                        SwapFirebaseUsers.storeUpdate(product: productHistory) { product in
                            self.dataSource = product.events ?? []
                        }
                    }
                }
            }
        })
    }
}


//MARK: - Table view related methods
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell:CardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as! CardTableViewCell
        userCell.setup(with: dataSource[indexPath.row])
        return userCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //handleSelection(of: indexPath.section == 0 ? menodagData[indexPath.row] : dataSource[indexPath.row])
    }
}
