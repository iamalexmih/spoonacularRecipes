//
//  DataManager.swift
//  spoonacularRecipes
//
//  Created by Иван Осипов on 09.03.2023.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private let key = "favoriteRecipes"
    
    private init() {}
    
    func save(favoriteRecipesID array: [Int]) {
        UserDefaults.standard.set(array, forKey: key)
    }
    
    func getFavoriteRecipesID() -> [Int] {
        return UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }
}
