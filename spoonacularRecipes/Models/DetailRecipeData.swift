//
//  DetailRecipeData.swift
//  spoonacularRecipes
//
//  Created by Иван Осипов on 01.03.2023.
//

import Foundation

struct DetailRecipe: Decodable {
    let readyInMinutes: Int?
    let title: String?
    let image: String?
    let id: Int?
    let extendedIngredients: [Ingredients]?
    let analyzedInstructions: [Instructions]?
}

struct Instructions: Decodable {
    let steps: [Steps]?
}

struct Ingredients: Decodable {
    let original: String?
    var isMarked: Bool?
}

struct Steps: Decodable {
    let number: Int?
    let step: String?
}
