//
//  NetworkService.swift
//  recipeSearch
//
//  Created by Ali on 09/08/2022.
//

import Foundation
import Alamofire

class NetworkService {
    func getAllRecipes(q: String, healthFilter: String, from: Int = 0, to: Int = 10, completionHandler: @escaping ( AllRecipes? , String?) -> Void) {
        var parameters: Parameters? = [:]
        
        parameters?["q"] = q
        parameters?["app_id"] = APIConfig.APP_ID
        parameters?["app_key"] = APIConfig.APP_KEY
        parameters?["from"] = from
        parameters?["to"] = to
        parameters?["field"] = APIConfig.FIELD_PARAM

        if !healthFilter.isEmpty {
            parameters?["health"] = healthFilter
        }
        
        AF.request(APIConfig.BASE_URL, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil, interceptor: nil, requestModifier: nil)
            .validate()
            .responseDecodable(of: AllRecipes.self) { (response) in
                switch response.result {
                case .success(let data):
                    if data.count == 0 {
                        completionHandler(nil, ErrorMessages.NO_DATA_FOUND)
                    }
                    completionHandler(data, nil)
                case .failure(let error):
                    if error.responseCode != 429 {
                        completionHandler(nil, ErrorMessages.SEARCH_FAILED)
                    } else {
                        completionHandler(nil, ErrorMessages.TOO_MANY_REQUESTS)
                    }
                }
            }
    }
}
