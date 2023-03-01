//
//  ViewController.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import UIKit

class MainViewController: UIViewController {

    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.delegate = self
        
//        networkService.fetchRecipesPopularity()
        networkService.fetchRecipesPopularity(byType: "bread")
    }
}


extension MainViewController: NetworkServiceProtocol {
    func getRecipesData(_ networkService: NetworkService, recipesData: Any) {
        if let recipes = recipesData as? ResultsData {
            print(recipes.results)
        }

    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}
