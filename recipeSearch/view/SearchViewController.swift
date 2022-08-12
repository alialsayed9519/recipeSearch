//
//  SearchViewController.swift
//  recipeSearch
//
//  Created by Ali on 09/08/2022.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    private var searchViewModel = SearchViewModel()
    private var recipes: [Hit] = []
    private var query:String? = nil
    private let searchController = UISearchController()
    private var currentSelectedHealthFilterBtn: UIButton!
    private let defaults = UserDefaults.standard
    private var recentSearchs: [String] = []
    @IBOutlet private weak var all: UIButton!
    @IBOutlet private weak var low: UIButton!
    @IBOutlet private weak var keto: UIButton!
    @IBOutlet private weak var vegan: UIButton!
    @IBOutlet weak var recentTableView: UITableView!
    @IBOutlet private weak var recipesTableView: UITableView!
    @IBOutlet weak var noDataFound: UIStackView!
    @IBOutlet weak var exploreView: UIStackView!
    @IBOutlet weak var healthFiltersView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipes Search"
        currentSelectedHealthFilterBtn = all
        currentSelectedHealthFilterBtn.backgroundColor = .blue
        searchController.searchBar.placeholder = "Search for recipe"
        defaults.set("", forKey: "healthFilter")
    
        initSearchView()
                
        searchViewModel.bindRecipesToView = {
            self.onSuccessUpdateView()
        }
        
        searchViewModel.bindRecipesErrorToView = {
            self.onFailUpdateView()
        }
    }

    func onSuccessUpdateView(){
       // exploreView.isHidden = true
        recipes = searchViewModel.recipes
        self.recipesTableView.reloadData()
    }
    
    func onFailUpdateView(){
        recipesTableView.isHidden = true
        exploreView.isHidden = true
        noDataFound.isHidden = false
    }
    
    @IBAction func allBtn(_ sender: Any) {
        switchHealthFilterBtn(selectedHealtFilterBtn: all, selectedHealtFilterValue: "")
    }
    
    @IBAction func lowSugerBtn(_ sender: Any) {
        switchHealthFilterBtn(selectedHealtFilterBtn: low, selectedHealtFilterValue: HealthFilters.LOW_SUGER)
    }
    
    @IBAction func ketoBtn(_ sender: Any) {
        switchHealthFilterBtn(selectedHealtFilterBtn: keto, selectedHealtFilterValue: HealthFilters.KETO)
    }
    
    @IBAction func veganBtn(_ sender: Any) {
        switchHealthFilterBtn(selectedHealtFilterBtn: vegan, selectedHealtFilterValue: HealthFilters.VEGAN)
    }
   
    private func switchHealthFilterBtn(selectedHealtFilterBtn: UIButton, selectedHealtFilterValue: String) {
        if currentSelectedHealthFilterBtn != selectedHealtFilterBtn {
            defaults.set(selectedHealtFilterValue, forKey: "healthFilter")
            currentSelectedHealthFilterBtn.backgroundColor = .systemGray3
            currentSelectedHealthFilterBtn = selectedHealtFilterBtn
            currentSelectedHealthFilterBtn.backgroundColor = .blue
            if query != "" && query != nil {
                searchViewModel.fetchAllRecipes(q: query ?? "", healthFilter: selectedHealtFilterValue)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        recentTableView.isHidden = true
        healthFiltersView.isHidden = false
        recipesTableView.isHidden = false
        query = searchBar.text!
        searchViewModel.fetchAllRecipes(q: query ?? "", healthFilter: defaults.string(forKey: "healthFilter")!)
        searchController.isActive = false
        searchController.searchBar.text = query!
       
        if recentSearchs.contains(query!) {
            recentSearchs.remove(at: recentSearchs.firstIndex(of: query!)!)
        }
        if recentSearchs.count == 10 {
            recentSearchs.remove(at: 9)
        }
        recentSearchs.insert(query!, at: 0)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if searchBar.text!.isEmpty && text == " " {return false}
        return searchTextIsValidate(text: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        recentTableView.isHidden = true
        recipesTableView.isHidden = false
        healthFiltersView.isHidden = false
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        healthFiltersView.isHidden = true
        recipesTableView.isHidden = true
        recentTableView.isHidden = false
        recentTableView.reloadData()
    }
    
    private func searchTextIsValidate(text:String)->Bool{
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz \n"
                       let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                       let typedCharacterSet = CharacterSet(charactersIn: text)
                       let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                       return alphabet
    }
  
    private func initSearchView() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case recentTableView:
            return recentSearchs.count
        default:
            return recipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case recentTableView:
            let cell1 =  tableView.dequeueReusableCell(withIdentifier: "RecentTableViewCell", for: indexPath)
            cell1.textLabel?.text = recentSearchs[indexPath.row]
            return cell1
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
            let index = indexPath.row
            cell.updateUi(recipe: recipes[index].recipe)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case recentTableView:
            searchViewModel.fetchAllRecipes(q: recentSearchs[indexPath.row] , healthFilter: defaults.string(forKey: "healthFilter")!)
            searchController.searchBar.text = recentSearchs[indexPath.row]
            recentTableView.isHidden = true
        default:
            let view: DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            view.recipe = recipes[indexPath.row].recipe
            self.navigationController!.pushViewController(view, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case recentTableView:
            return 20
        default:
            return 130
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == recipes.count - 1 {
            searchViewModel.getNextRecipePage(q: query, healthFilter: defaults.string(forKey: "healthFilter")!, to: recipes.count)
        }
    }
}


