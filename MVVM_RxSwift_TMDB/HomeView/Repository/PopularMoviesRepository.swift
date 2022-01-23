//
//  PopularMoviesRepository.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 20/1/22.
//

import Foundation

class PopularMoviesRepository {
    
    func getPopularMovies(success: @escaping ([Movie])->(), failure: @escaping (Error)->()) {
        let urlString = "\(Constants.API.URL.urlMainSite)\(Constants.API.Endpoints.urlEndpointListMovies)\(Constants.API.apiKeyBridge)\(Constants.API.apiKeyValue)"//\(Constants.API.Params.paramPage)\(page)
        //print("URL - getPopularMovies: \(urlString)")
        
        ManagerConnections.shared.fetchData(urlString: urlString) { data in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Movies.self, from: data)
                let movies = response.listOfMovies
                success(movies)
                return
            } catch _ {
                failure(NetworkErrors.decodingJSONError)
                return
            }
        } failure: { error in
            failure(error)
            return
        }
    }
    
}
