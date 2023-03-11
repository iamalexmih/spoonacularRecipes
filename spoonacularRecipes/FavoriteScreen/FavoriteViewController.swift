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
        title = "Favorite Recipes"
        if countFavorute != FavoriteRecipe.shared.favoriteListIdRecipe.count {
            getPopularRecipes()
        }        
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
    
    override func didPressFavoriteButton(isFavorite status: Bool, idRecipe: Int) {
        super.didPressFavoriteButton(isFavorite: status, idRecipe: idRecipe)
            if !status {
                listOfRecipes.removeAll { recipe in
                    recipe.id == idRecipe
                }
            }
            tableView.reloadData()
    }
}
