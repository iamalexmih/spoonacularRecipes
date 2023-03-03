//
//  CategoryRecipesViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

class CategoryRecipesViewController: UIViewController {
    
    let source: [CategoryRecipes] = CategoryRecipes.getAllCategories()
    var recipes: [RecipeCard] = []
    let networkService = NetworkService()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setConstraints()
        
        networkService.delegate = self
    }
}

// MARK: - Private methods, setup

private extension CategoryRecipesViewController {
    func setup() {
        title = "Category Recipes"
        view.backgroundColor = .systemBackground
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 200
        
        // отключить разделитеть между ячейками
        tableView.separatorStyle = .none
        // отключить индикатор вертикального скролла
//        tableView.showsVerticalScrollIndicator = false

        tableView.register(CateroryCell.self, forCellReuseIdentifier: String(describing: CateroryCell.self))
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}

// MARK: - UITableViewDataSource

extension CategoryRecipesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CateroryCell.self), for: indexPath) as! CateroryCell
        
        let textTitle = source[indexPath.row].title.rawValue.capitalized
        let imageName = source[indexPath.row].ImageName
        
        cell.configure(title: textTitle, and: imageName)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryRecipesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CateroryCell
        let categoryType = cell.titleLabel.text!.lowercased()
        
        print("\(categoryType)")
            
        networkService.fetchRecipesPopularity(byType: categoryType)
        
        let vc = MainViewController()
        vc.list = recipes
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryRecipesViewController: NetworkServiceProtocol {
    func getRecipesData(_ networkService: NetworkService, recipesData: Any) {
        
        let allData = recipesData as! ResultsData
        var arr: [RecipeCard] = []
        for item in allData.results {
            let recipeItem = RecipeCard(title: item.title, imageName: item.image)
            arr.append(recipeItem)
        }
        
        recipes.append(contentsOf: arr)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
