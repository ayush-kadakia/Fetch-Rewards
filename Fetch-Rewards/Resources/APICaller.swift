//
//  APICaller.swift
//  Fetch-Rewards
//
//  Created by Ayush Kadakia on 5/2/23.
//

import Foundation
import Alamofire

struct Constants {
    static let mealsURL = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    ///singleton design pattern for APIs
    static let shared = APICaller()
    
    ///fetch the meals
    func fetchMeals(completion: @escaping (Result<[Meal], Error>) -> Void){
        guard let mealsURL = URL(string: Constants.mealsURL) else { return }
        
        AF.request(mealsURL).validate().response { response in
            switch response.result {
            case .success(_):
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let results = try decoder.decode(MealsResponse.self, from: data)
                        let filteredMeals = results.meals.filter{
                            //filter out empty and null values
                            !$0.strMeal.isEmpty
                        }
                        .sorted {
                            //sort alphabetically
                            $0.strMeal.lowercased() < $1.strMeal.lowercased()
                        }
                        completion(.success(filteredMeals))
                    } catch {
                        print(error)
                    }
                }
            case .failure(_):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
    
    //fetch meal info by ID
    func fetchMealById(idMeal: String, completion: @escaping (Result<Meal, Error>) -> Void) {
        let mealsURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(idMeal)"

        AF.request(mealsURL).validate().response { response in
            switch response.result {
            case .success(_):
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let results = try decoder.decode(MealsResponse.self, from: data)
                        if let meal = results.meals.first {
                            completion(.success(meal))
                        }
                    } catch {
                        print(error)
                    }
                }
            case .failure(_):
                completion(.failure(APIError.failedTogetData))
            }
        }
    }
    
}
