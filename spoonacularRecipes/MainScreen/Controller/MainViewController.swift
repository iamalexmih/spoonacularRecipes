//
//  ViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

struct PopularRecipe {
    
    let title: PopularList
    var imageName: String {
        return title.rawValue
    }
    
    static func getAllPopular() -> [PopularRecipe] {
        var result: [PopularRecipe] = []
        PopularList.allCases.forEach {
            result.append(.init(title: $0))
        }
        return result
    }
    
    enum PopularList: String, CaseIterable {
        case mainCource = "main course"
        case sideDish = "side dish"
        case dessert
        case appetizer
        case salad
        case bread
        case breakfast
        case soup
        case beverage
        case sauce
        case marinade
        case fingerfood
        case snack
        case drink
    }
    
}

class MainViewController: UIViewController {
    let list: [PopularRecipe] = PopularRecipe.getAllPopular()
    let tableView = UITableView()

    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setConstraints()
        
        networkService.delegate = self
        
//        networkService.fetchRecipesPopularity()
        networkService.fetchRecipesPopularity(byType: "bread")
    }
}

//MARK: - Private Methods / Setup
private extension MainViewController {
    func setup() {
        title = "Popular Recipes"
        //view.addGradientBackground(firstColor: .white, secondColor: .black)
        //view.addBlackGradientLayerInBackground(frame: view.bounds, colors: [.clear, .black])
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
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PopularCell.self), for: indexPath) as! PopularCell
        
        let textTitle = list[indexPath.row].title.rawValue.capitalized
        let imageName = list[indexPath.row].imageName
        cell.configureCell(title: textTitle, image: imageName)
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PopularCell
        let favoriteName = cell.titleLabel.text!
        
        if let tabBarController = self.tabBarController, let vc = tabBarController.viewControllers?[1] as? MainViewController {
            
        }
    }
}

extension MainViewController: NetworkServiceProtocol {
    func getRecipesData(_ networkService: NetworkService, recipesData: Any) {
        if let recipes = recipesData as? ResultsData {
            print(recipes.results)
        }

    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}
