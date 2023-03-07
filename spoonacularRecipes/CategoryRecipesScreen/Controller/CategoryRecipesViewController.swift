//
//  CategoryRecipesViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

class CategoryRecipesViewController: UIViewController {
    
    private let cellHeight: CGFloat = 250
    
    let source: [RecipeCard] = getAllCategories()
    let networkService = NetworkService()
    var sectionName = "Category Recipes"
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
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
        title = sectionName
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
    
    func getRecipesArrayFrom(data: ResultsData) -> [RecipeCard] {
        var recipes: [RecipeCard] = []
        for item in data.results {
            recipes.append(RecipeCard(id: item.getId(), title: item.getTitle(), imageName: item.getImage()))
        }
        
        return recipes
    }
}

// MARK: - UITableViewDataSource

extension CategoryRecipesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CateroryCell.self), for: indexPath) as! CateroryCell
        
        let textTitle = source[indexPath.row].getTitle().capitalized
        let imageName = source[indexPath.row].getImage()
        
        cell.configure(title: textTitle, and: imageName)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryRecipesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CateroryCell
        let categoryType = cell.titleLabel.text!
        networkService.fetchRecipesPopularity(byType: categoryType.lowercased()) { [weak self] (result) in
            switch result {
            case .success(let data):
                if let recipes = self?.getRecipesArrayFrom(data: data as! ResultsData) {
                    DispatchQueue.main.async {
                        let vc = MainViewController()
                        vc.list = recipes
                        vc.sectionName = categoryType
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
