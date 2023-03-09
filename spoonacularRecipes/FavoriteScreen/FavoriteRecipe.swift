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
}
