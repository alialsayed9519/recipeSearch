//
//  DetailsViewController.swift
//  recipeSearch
//
//  Created by Ali on 09/08/2022.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {
    @IBOutlet private(set) weak var ingredientLinesTableView: UITableView!
    @IBOutlet private(set) weak var recipeImage: UIImageView!
    @IBOutlet private(set) weak var recipeTitle: UILabel!
    private var ingredientLines: [String] = []
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "shareplay"), style: .plain, target: self, action: #selector(self.shareRecipeURLBtn))
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        self.title = "Recipes Details"
        recipeImage.sd_setImage(with: URL(string: recipe.image), placeholderImage: UIImage(named: "recipeImage.png"))
        recipeTitle.text = recipe.title
        ingredientLines = recipe.ingredientLines
    }

    @objc func shareRecipeURLBtn() {
        let textToShare = [recipe.url]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func openRecipeWebsiteBtn(_ sender: Any) {
        if let url = URL(string: recipe.url) {
               let config = SFSafariViewController.Configuration()
               config.entersReaderIfAvailable = true

               let vc = SFSafariViewController(url: url, configuration: config)
               present(vc, animated: true)
        }
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientLines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientLines", for: indexPath)
        cell.textLabel?.text = ingredientLines[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredient Lines"
    }
}
