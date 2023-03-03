//
//  RecipeData.swift
//  spoonacularRecipes
//
//  Created by Никита Ясеник on 03.03.2023.
//

import Foundation

//enum PopularList: String, CaseIterable {
//    case mainCource = "main course"
//    case sideDish = "side dish"
//    case dessert
//    case appetizer
//    case salad
//    case bread
//    case breakfast
//    case soup
//    case beverage
//    case sauce
//    case marinade
//    case fingerfood
//    case snack
//    case drink
//}

enum Category: String, CaseIterable {
    case mainCource = "main course"
    case sideDish = "side dish"
    case dessert
    case appetizer
    case salad
    case bread
    case breakfast
    case soup
    case beverage
    case sauce
    case marinade
    case fingerfood
    case snack
    case drink
}

struct RecipeData: Decodable {

    let id: Int
    let title: String
    let image: String

}

struct RecipeCard: Decodable {
    
    let title: String
    var imageName: String
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
    
    static func getAllPopular() -> [RecipeCard] {
        var result: [RecipeCard] = []
        Category.allCases.forEach {
            result.append(.init(title: $0.rawValue, imageName: $0.rawValue))
        }
        return result
    }
    
}

struct CategoryRecipes {
    
    let title: Category
    var ImageName: String {
        return title.rawValue
    }
    
    // возращает массив со всеми категориями
    static func getAllCategories() -> [CategoryRecipes] {
        var result: [CategoryRecipes] = []
        Category.allCases.forEach {
            result.append(.init(title: $0))
        }
        return result
    }
}

struct ResultsData: Decodable {
    let results: [RecipeData]
}
