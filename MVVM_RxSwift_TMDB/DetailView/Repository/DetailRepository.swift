//
//  DetailRepository.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 30/1/22.
//

import Foundation
import RxSwift


// MARK: DetailRepositoryProtocol
protocol DetailRepositoryProtocol: AnyObject {
    func getMovieImage(imageString: String) -> Observable<UIImage>
    func getMovieDetail(movieID: String) -> Observable<MovieDetail>
}


// MARK: DetailRepositoryProtocol
class DetailRepository: DetailRepositoryProtocol {
    
    func getMovieDetail(movieID: String) -> Observable<MovieDetail> {
        let urlString = "\(Constants.API.URL.urlMainSite)\(Constants.API.Endpoints.urlEndpointDetailMovie)\(movieID)\(Constants.API.apiKeyBridge)\(Constants.API.apiKeyValue)"
        //print("URL - getMovieDetail: \(urlString)")
        
        return ManagerConnections.shared.fetchData(urlString: urlString)
            .observe(on: MainScheduler.instance)
            .subscribe(on: MainScheduler.instance)
            .map { movieData in
                do {
                    let decoder = JSONDecoder()
                    let movie = try decoder.decode(MovieDetail.self, from: movieData)
                    return movie
                } catch _ {
                    throw NetworkErrors.decodingJSONError
                }
            }
    }
    
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
    
}
