//
//  DetailRecipeToDo.swift
//  spoonacularRecipes
//
//  Created by Eduard Tokarev on 09.03.2023.
//

import Foundation

struct DetailRecipeTodo: Decodable {
    let readyInMinutes: Int?
    let title: String?
    let image: String?
    var ingredients: [Ingredients]?
    let analyzedInstructions: [Instructions]?
    
    init(from result: DetailRecipe) {
        self.readyInMinutes = result.readyInMinutes
        self.title = result.title
        self.image = result.image
        self.analyzedInstructions = result.analyzedInstructions
        
        let ingredients = result.extendedIngredients
        guard let ingredients else { return }
        var newIngredients = ingredients
        for i in 0..<ingredients.count {
            newIngredients[i].isMarked = false
        }
        
        self.ingredients = newIngredients
    }
}
