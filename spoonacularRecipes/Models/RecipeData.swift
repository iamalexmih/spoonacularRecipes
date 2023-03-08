//
//  RecipeData.swift
//  spoonacularRecipes
//
//  Created by Никита Ясеник on 03.03.2023.
//

import Foundation

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

struct ResultData: Decodable {
    let results: [RecipeCard]
}

struct RecipeCard: Decodable {
    let id: Int
    let title: String
    let image: String
}

// TODO: Удалить
//struct RecipeCard: Decodable {
//
//    private let id: Int
//    private let title: String
//    private let image: String
//
//    init(id: Int, title: String, imageName: String) {
//        self.id = id
//        self.title = title
//        self.image = imageName
//    }
//}


// TODO: Удалить
//extension RecipeCard {
//
//    func getId() -> Int {
//        return id
//    }
//
//    func getTitle() -> String {
//        return title
//    }
//
//    func getImage() -> String {
//        return image
//    }
//}

func getAllCategories() -> [RecipeCard] {
    var result: [RecipeCard] = []
    var uniqueId = 0
    Category.allCases.forEach {
        result.append(.init(id: uniqueId, title: $0.rawValue, image: $0.rawValue))
        uniqueId += 1
    }
    return result
}
