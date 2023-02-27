//
//  CategoryRecipesViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

struct CategoryRecipes {
    
    let title: CategoryTypes
    var Image: String {
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
        setConstraints()
    }
    
}

// MARK: - Private methods, setup

private extension CategoryRecipesViewController {
    func setup() {
        // view settings
        view.backgroundColor = .systemBackground
        
        // tableView settings
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.register(CateroryCell.self, forCellReuseIdentifier: String(describing: CateroryCell.self))
        
        tableView.dataSource = self
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}

// MARK: - UITableViewDataSource

extension CategoryRecipesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source.count % 2 == 0 ? source.count / 2 : source.count / 2 + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CateroryCell.self), for: indexPath) as! CateroryCell
        
        cell.configure(source[indexPath.row].title.rawValue)
        
        return cell
    }
}
