//
//  ViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private let heightCell: CGFloat = 230
    let searchController = UISearchController(searchResultsController: nil)
    
    // проверка есть ли значение в строке поиска
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    // возвращает true ейли строка поиска активирована и не является пустой
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var filtredListOfRecipes: [RecipeCard] = []
    
    var listOfRecipes: [RecipeCard] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    var sectionName = "Popular Recipes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearanceScreen()
        setupTableView()
        setupSearchController()
        setLayout()
        getPopularRecipes()
        FavoriteRecipe.shared.favoriteListIdRecipe = DataManager.shared.getFavoriteRecipesID()
        print("favoriteListIdRecipe ",FavoriteRecipe.shared.favoriteListIdRecipe)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - Delegate for Favorite Button

extension MainViewController: FavoriteRecipeDelegate {
    @objc func didPressFavoriteButton(isFavorite status: Bool, idRecipe: Int) {
        if FavoriteRecipe.shared.check(id: idRecipe) {
            FavoriteRecipe.shared.remove(id: idRecipe)
        } else {
            FavoriteRecipe.shared.favoriteListIdRecipe.append(idRecipe)
        }
        
        // сохранения массива в UserDefauts
        let recipesID = FavoriteRecipe.shared.favoriteListIdRecipe
        DataManager.shared.save(favoriteRecipesID: recipesID)
    }
}

// MARK: - Network

extension MainViewController {
    @objc func getPopularRecipes() {
        // проверка, если есть данные выйдет из метода
        if !listOfRecipes.isEmpty {
            return
        }
        
        NetworkService.shared.fetchRecipesPopularity { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.listOfRecipes = data.results
                }
            case .failure(_):
                print("Error, .....")
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailRecipeViewController()
        let selectIdRecipe = listOfRecipes[indexPath.row].id
        vc.idRecipe = selectIdRecipe
        vc.isFavorite = FavoriteRecipe.shared.check(id: selectIdRecipe)
        vc.delegateFavoriteButton = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell
    }
}


// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filtredListOfRecipes.count
        } else {
            return listOfRecipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainCell.self), for: indexPath) as! MainCell
        
        cell.delegateFavoriteButton = self
        let indexRow = indexPath.row
        
        switch listOfRecipes.isEmpty {
        case true:
            print("не удалось сконфигурировать ячейку")
        case false where isFiltering == true:
            
            let text = filtredListOfRecipes[indexRow].title
            let imageName = filtredListOfRecipes[indexRow].image
            let idRecipe = filtredListOfRecipes[indexRow].id
            let isFavorite = FavoriteRecipe.shared.check(id: filtredListOfRecipes[indexRow].id)
            
            cell.configureCell(text, imageName, isFavorite, idRecipe: idRecipe)
            
        case false where isFiltering == false:
            
            let text = listOfRecipes[indexRow].title
            let imageName = listOfRecipes[indexRow].image
            let idRecipe = listOfRecipes[indexRow].id
            let isFavorite = FavoriteRecipe.shared.check(id: listOfRecipes[indexRow].id)
            
            cell.configureCell(text, imageName, isFavorite, idRecipe: idRecipe)
            
        case false:
            print("В теории никогда не будет вызван")
        }
        
        return cell
    }
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filtredContentForSearchText(searchController.searchBar.text!)
    }
    
    func filtredContentForSearchText(_ searchText: String) {
        filtredListOfRecipes = listOfRecipes.filter({ item in
            return item.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}


// MARK: - Setup TableView, Layout, configure Appearance Screen

private extension MainViewController {
    
    func configureAppearanceScreen() {
        title = sectionName
        view.backgroundColor = .systemBackground
    }
    
    func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = heightCell
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainCell.self, forCellReuseIdentifier: String(describing: MainCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
