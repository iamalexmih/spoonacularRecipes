//
//  PopularRecipeData.swift
//  spoonacularRecipes
//
//  Created by Иван Осипов on 01.03.2023.
//

import Foundation

struct ResultsData: Decodable {
    let results: [PopularRecipesData]
}

struct PopularRecipesData: Decodable {
    let id: Int
    let title: String
    let image: String
}
