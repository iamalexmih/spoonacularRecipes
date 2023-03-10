//
//  FavoriteRecipe.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 09.03.2023.
//

import Foundation


class FavoriteRecipe {
    static let shared = FavoriteRecipe()
    private init() { }
    
    
    var favoriteListIdRecipe: [Int] = []
    
    func check(id: Int) -> Bool {
        favoriteListIdRecipe.contains(id)
    }
    
    func remove(id: Int) {
        if let index = favoriteListIdRecipe.firstIndex(of: id) {
            favoriteListIdRecipe.remove(at: index)
        }
    }
}
