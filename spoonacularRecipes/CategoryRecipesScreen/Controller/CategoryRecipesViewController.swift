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
    private var sectionName = "Category Recipes"
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearanceView()
        setupTableView()
        setConstraints()
    }
}


// MARK: - Network and Push to Main ViewController

private extension CategoryRecipesViewController {
    func fetchRecipesPopularity(_ categoryType: String) {
        NetworkService.shared.fetchRecipesPopularity(byType: categoryType.lowercased()) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let mainViewController = MainViewController()
                    mainViewController.listOfRecipes = data.results
                    self.navigationController?.pushViewController(mainViewController, animated: true)
                }
            case .failure(_):
                print("Переход к MainViewController не удался")
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension CategoryRecipesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CateroryCell.self), for: indexPath) as! CateroryCell
        
        let textTitle = source[indexPath.row].title.capitalized
        let imageName = source[indexPath.row].image
        
        cell.configure(title: textTitle, and: imageName)
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension CategoryRecipesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CateroryCell
        let categoryType = cell.titleLabel.text!
        fetchRecipesPopularity(categoryType)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}


// MARK: - Private methods, setup

private extension CategoryRecipesViewController {
    func setupAppearanceView() {
        title = sectionName
        view.backgroundColor = .white
    }
    
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 250
        // отключить разделитеть между ячейками
        tableView.separatorStyle = .none
        // отключить индикатор вертикального скролла
        // tableView.showsVerticalScrollIndicator = false
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
