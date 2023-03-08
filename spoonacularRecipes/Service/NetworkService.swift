//
//  NetworkService.swift
//  spoonacularRecipes
//
//  Created by Алексей Попроцкий on 27.02.2023.
//

import Foundation



class NetworkService {
    
    static let shared = NetworkService()
    private init() { }
    
    private let baseURL = "https://api.spoonacular.com/recipes"
//    private let apiKey = "ec302cd3ae2e439b9558cc79d26c5efa"
    private let apiKey = "8fb252dbc5db455aa22b7c3f5d0a952b"
//    private let apiKey = "1d725eb876444268ae0f53d1bcbe8b44"
    
    
    //TODO: Удалить если не нужен. Уже не используется. За место него fetchRecipes()
    // по id, конкретный рецепт
//    func fetchRecipe(byID id: Int,
//                     completion: @escaping (Result<Decodable, Error>) -> Void) {
//        
//        let urlString = "\(baseURL)/\(id)/information/?apiKey=\(apiKey)"
//
//        performRequest(with: urlString, type: DetailRecipe.self) { (result) in
//            switch result {
//            case .success(let data):
//                completion(.success(data))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    // запрос по массиву ID рецептов
    func fetchRecipes(byIDs idArray: [Int], complitionHandler: @escaping (Result<[DetailRecipe], Error>) -> Void) {
        
        let urlString = createURLString(from: idArray)
        performRequest(with: urlString, type: [DetailRecipe].self) { result in
            switch result {
            case .failure(let error):
                complitionHandler(.failure(error))
            case .success(let data):
                complitionHandler(.success(data))
            }
        }
    }
    
    private func createURLString(from ids: [Int]) -> String {
        var idList = ""
        ids.forEach { id in
            idList += String(id) + ","
        }
        let urlString = "\(baseURL)/informationBulk?apiKey=\(apiKey)&ids=\(idList)"
        
        return urlString
    }
    
    
    /// массив популярных рецептов
    func fetchRecipesPopularity(completion: @escaping (Result<ResultData, Error>) -> Void) {
        let urlString = "\(baseURL)/complexSearch?apiKey=\(apiKey)&sort=popularity"
        performRequest(with: urlString, type: ResultData.self) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// массив популярных рецептов по категории
    func fetchRecipesPopularity(byType type: String,
                                completion: @escaping (Result<ResultData, Error>) -> Void) {
        let urlString = "\(baseURL)/complexSearch?apiKey=\(apiKey)&type=\(type)&sort=popularity"
        performRequest(with: urlString, type: ResultData.self) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRequest<T: Decodable>(with urlString: String,
                                              type: T.Type,
                                completion: @escaping (Result<T, RecipeError>) -> Void) {
        let newUrl = urlString.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: newUrl) else {
            completion(.failure(.urlNotCreate))
            return
            
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            let statusCode = response.statusCode
            print(statusCode)
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
