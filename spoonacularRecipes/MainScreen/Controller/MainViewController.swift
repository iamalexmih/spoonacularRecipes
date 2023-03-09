//
//  ViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    var listOfRecipes: [RecipeCard] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let tableView = UITableView()
    var sectionName = "Popular Recipes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearanceScreen()
        setupTableView()
        setLayout()
        getPopularRecipes()
        FavoriteRecipe.shared.favoriteListIdRecipe = DataManager.shared.getFavoriteRecipesID()
        print("favoriteListIdRecipe ",FavoriteRecipe.shared.favoriteListIdRecipe)
    }
}

// MARK: - Delegate for Favorite Button

extension MainViewController: PopularCellDelegate {
    func didPressFavoriteButton(_ cell: PopularCell, button: UIButton) {
        print("select recipt: \(cell.titleLabel.text!)")
    }
}


// MARK: - Network

private extension MainViewController {
    func getPopularRecipes() {
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
        if !listOfRecipes.isEmpty {
            let vc = DetailRecipeViewController()
            vc.idRecipe = listOfRecipes[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("не удалось получить ИД и осуществить переход на DetailRecipeViewController")
        }
    }
}


// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PopularCell.self), for: indexPath) as! PopularCell
        
        cell.delegate = self
        
        if !listOfRecipes.isEmpty {
            let text = listOfRecipes[indexPath.row].title
            let imageName = listOfRecipes[indexPath.row].image
            let idRecipe = listOfRecipes[indexPath.row].id
            cell.configureCell(text, imageName, idRecipe)
        } else {
            print("не удалось сконфигурировать ячейку")
        }
        
        return cell
    }
}


// MARK: - Setup TableView, Layout, configure Appearance Screen

private extension MainViewController {
    
    func configureAppearanceScreen() {
        title = sectionName
        view.backgroundColor = .systemBackground
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PopularCell.self, forCellReuseIdentifier: String(describing: PopularCell.self))
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
