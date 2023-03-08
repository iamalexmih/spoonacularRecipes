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
//    private let apiKey = "ec302cd3ae2e439b9558cc79d26c5efa"
//    private let apiKey = "1d725eb876444268ae0f53d1bcbe8b44"
    private let apiKey = "e2e56101f2714c91895e7132e44e60e0"
    
    var delegate: NetworkServiceProtocol?
    
    // по id, конкретный рецепт
    func fetchRecipe(byID id: Int,
                     completion: @escaping (Result<Decodable, Error>) -> Void) {
        let urlString = "\(baseURL)/\(id)/information/?apiKey=\(apiKey)"
        performRequest(with: urlString, type: DetailRecipe.self) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // популярные рецепты
    func fetchRecipesPopularity(completion: @escaping (Result<Decodable, Error>) -> Void) {
        let urlString = "\(baseURL)/complexSearch?apiKey=\(apiKey)&sort=popularity"
        performRequest(with: urlString, type: ResultsData.self) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // популярные категории
    func fetchRecipesPopularity(byType type: String,
                                completion: @escaping (Result<Decodable, Error>) -> Void) {
        let urlString = "\(baseURL)/complexSearch?apiKey=\(apiKey)&type=\(type)&sort=popularity"
        performRequest(with: urlString, type: ResultsData.self) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRequest(with urlString: String,
                                type: Decodable.Type,
                                completion: @escaping (Result<Decodable, RecipeError>) -> Void) {
        let newUrl = urlString.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: newUrl) else {
            completion(.failure(.urlNotCreate))
            return
            
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.internetConnectionLost))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
                
            }
            do {
                if let decodedData = try? JSONDecoder().decode(type.self, from: data) {
                    completion(.success(decodedData))
                } else {
                    completion(.failure(.decodeError))
                }
            }
        }
        task.resume()
    }
}
