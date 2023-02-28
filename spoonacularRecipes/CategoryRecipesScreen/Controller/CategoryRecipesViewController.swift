//
//  CategoryRecipesViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

struct CategoryRecipes {
    
    let title: CategoryTypes
    var ImageName: String {
        return title.rawValue
    }
    
    // возращает массив со всеми категориями
    static func getAllCategories() -> [CategoryRecipes] {
        var result: [CategoryRecipes] = []
        CategoryTypes.allCases.forEach {
            result.append(.init(title: $0))
        }
        return result
    }
    
    enum CategoryTypes: String, CaseIterable {
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

class CategoryRecipesViewController: UIViewController {
    
    let source: [CategoryRecipes] = CategoryRecipes.getAllCategories()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setConstraints()
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
        
        if let tabBarController = self.tabBarController,
            let vc = tabBarController.viewControllers?[0] as? MainViewController {
                // transfer data
        }
    }
}
