//
//  HomeRepository.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 20/1/22.
//

import Foundation
import RxSwift


// MARK: HomeRepositoryProtocol
protocol HomeRepositoryProtocol: AnyObject {
    func getMovieImage(imageString: String) -> Observable<UIImage>
    func getPopularMovies() -> Observable<[Movie]>
}


// MARK: HomeRepositoryProtocol
class HomeRepository: HomeRepositoryProtocol {
    
    func getMovieImage(imageString: String) -> Observable<UIImage> {
        let urlString = Constants.API.URL.urlMainImagesW200 + imageString
        //print("URL - getMovieImage: \(urlString)")
        
        return ManagerConnections.shared.fetchData(urlString: urlString)
            .observe(on: MainScheduler.instance)
            .subscribe(on: MainScheduler.instance)
            .map { imageData in
                do {
                    if let image = UIImage(data: imageData) {
                        return image
                    } else {
                        throw NetworkErrors.retrievingImage
                    }
                } catch _ {
                    throw NetworkErrors.decodingJSONError
                }
            }
        
    }
    
    func getPopularMovies() -> Observable<[Movie]> {
        let urlString = "\(Constants.API.URL.urlMainSite)\(Constants.API.Endpoints.urlEndpointListMovies)\(Constants.API.apiKeyBridge)\(Constants.API.apiKeyValue)"
        //\(Constants.API.Params.paramPage)\(page)
        
        return ManagerConnections.shared.fetchData(urlString: urlString)
            .observe(on: MainScheduler.instance)
            .subscribe(on: MainScheduler.instance)
            .map { moviesData in
                do {
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode(Movies.self, from: moviesData)
                    return movies.listOfMovies
                } catch _ {
                    throw NetworkErrors.decodingJSONError
                }
            }
    }
    
}
