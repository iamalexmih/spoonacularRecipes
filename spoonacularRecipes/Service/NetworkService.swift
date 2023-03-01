//
//  NetworkService.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func getRecipesData(_ networkService: NetworkService, recipesData: Any)
    func didFailWithError(error: Error)
}


class NetworkService {
    private let baseURL = "https://api.spoonacular.com/recipes"
    private let apiKey = "ec302cd3ae2e439b9558cc79d26c5efa"
    
    var delegate: NetworkServiceProtocol?
    
    // по id, конкретный рецепт
    func fetchRecipe(byID id: Int) {
        let urlString = "\(baseURL)/\(id)/information/?apiKey=\(apiKey)"
        performRequest(with: urlString, type: DetailRecipe.self)
    }
    
    // популярные рецепты
    func fetchRecipesPopularity() {
        let urlString = "\(baseURL)/complexSearch?apiKey=\(apiKey)&sort=popularity"
        performRequest(with: urlString, type: ResultsData.self)
    }
    
    // популярные категории
    func fetchRecipesPopularity(byType type: String) {
        let urlString = "\(baseURL)/complexSearch?apiKey=\(apiKey)&type=\(type)&sort=popularity"
        performRequest(with: urlString, type: ResultsData.self)
    }
    
    private func performRequest(with urlString: String, type: Decodable.Type) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
            }
            
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                self.delegate?.getRecipesData(self, recipesData: decodedData)
            } catch {
                self.delegate?.didFailWithError(error: error)
            }
        }
        task.resume()
    }
}
