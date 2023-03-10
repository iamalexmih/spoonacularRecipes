//
//  FavoriteViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

class FavoriteViewController: MainViewController {
    
    var countFavorute: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if countFavorute != FavoriteRecipe.shared.favoriteListIdRecipe.count {
            getPopularRecipes()
        }
        
//        tableView.reloadData() // reloadData делается в MainViewController в didSet для listOfRecipes
    }
    
    override func getPopularRecipes() {
        NetworkService.shared.fetchRecipes(byIDs: FavoriteRecipe.shared.favoriteListIdRecipe) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.listOfRecipes = data.map {  RecipeCard(id: $0.id ?? 0, title: $0.title ?? "", image: $0.image ?? "") }
                    self.countFavorute = self.listOfRecipes.count
                }
            case .failure(_):
                print("Error, .....")
            }
        }
    }
    
    override func didPressFavoriteButton(_ cell: MainCell, likeButton: UIButton, isFavorite status: Bool) {
        super.didPressFavoriteButton(cell, likeButton: likeButton, isFavorite: status)
        
        if let indexPath = tableView.indexPath(for: cell) {
            if !status {
                listOfRecipes.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
    }
    
//    override func didPressFavoriteButton(_ idRecipe: Int) {
//        listOfRecipes.removeAll { recipe in
//            recipe.id == idRecipe
//        }
//        tableView.reloadData()
//    }
}
