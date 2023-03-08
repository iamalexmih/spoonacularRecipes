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
        setup()
        setupTableView()
        setConstraints()
        getPopularRecipes()
    }
}

// MARK: - Private Methods / Setup

private extension MainViewController {
    func setup() {
        title = sectionName
        view.backgroundColor = .systemBackground
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PopularCell.self, forCellReuseIdentifier: String(describing: PopularCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
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
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MainViewController: PopularCellDelegate {
    func didPressFavoriteButton(_ cell: PopularCell, button: UIButton) {
        print("select recipt: \(cell.titleLabel.text!)")
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
            cell.configureCell(title: text, image: imageName)
        } else {
            print("не удалось сконфигурировать ячейку")
        }
        
        return cell
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
