//
//  ManagerConnections.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 20/1/22.
//

import Foundation
import RxSwift

class ManagerConnections {
    
    // Singleton
    static var shared : ManagerConnections {
        let instance = ManagerConnections()
        return instance
    }
    
    // Llamada desde la clase repositorio (con callbacks)
    func fetchData(urlString: String, success: @escaping (Data)->(), failure: @escaping (Error)->()) {
        
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if data == nil, error != nil {
                failure(NetworkErrors.unknownError)
                return
            }
            
            if let data = data, let httpUrlResponse = response as? HTTPURLResponse {
                let statusCode = httpUrlResponse.statusCode
                switch statusCode {
                case 200:
                    success(data)
                    break
                case 401:
                    failure(NetworkErrors.statusCode401UnauthorizedError)
                    break
                case 403:
                    failure(NetworkErrors.statusCode403ForbiddenError)
                    break
                case 404:
                    failure(NetworkErrors.statusCode404NotFoundError)
                    break
                default:
                    failure(NetworkErrors.statusCodeGenericError)
                    break
                }
                return
            } else {
                failure(NetworkErrors.unknownError)
                return
            }
            
        }.resume()
        
    }
    
    // Llamada desde el VM con RxSwift - Image
    func getMovieImage(imageString: String) -> Observable<UIImage> {
        
        return Observable.create { observer in
            let urlString = Constants.API.URL.urlMainImagesW200 + imageString
            //print("URL - getMovieImage: \(urlString)")
            let urlRequest = URLRequest(url: URL(string: urlString)!)
            
            let session = URLSession.shared
            session.dataTask(with: urlRequest) { data, response, error in
                if data == nil, error != nil {
                    observer.onError(NetworkErrors.unknownError)
                    return
                }
                
                if let data = data, let httpUrlResponse = response as? HTTPURLResponse {
                    let statusCode = httpUrlResponse.statusCode
                    switch statusCode {
                    case 200:
                        if let image = UIImage(data: data) {
                            observer.onNext(image)
                        } else {
                            observer.onError(NetworkErrors.retrievingImage)
                        }
                        break
                    case 401:
                        observer.onError(NetworkErrors.statusCode401UnauthorizedError)
                        break
                    case 403:
                        observer.onError(NetworkErrors.statusCode403ForbiddenError)
                        break
                    case 404:
                        observer.onError(NetworkErrors.statusCode404NotFoundError)
                        break
                    default:
                        observer.onError(NetworkErrors.statusCodeGenericError)
                        break
                    }
                    return
                } else {
                    observer.onError(NetworkErrors.unknownError)
                    return
                }
                
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    }
    
    
    // Llamada desde el VM con RxSwift - Popular Movies
    func getPopularMovies() -> Observable<[Movie]> {
        
        return Observable.create { observer in
            let urlString = "\(Constants.API.URL.urlMainSite)\(Constants.API.Endpoints.urlEndpointListMovies)\(Constants.API.apiKeyBridge)\(Constants.API.apiKeyValue)"//\(Constants.API.Params.paramPage)\(page)
            //print("URL - getPopularMovies: \(urlString)")
            let urlRequest = URLRequest(url: URL(string: urlString)!)
            
            let session = URLSession.shared
            session.dataTask(with: urlRequest) { data, response, error in
                if data == nil, error != nil {
                    observer.onError(NetworkErrors.unknownError)
                    return
                }
                
                if let data = data, let httpUrlResponse = response as? HTTPURLResponse {
                    let statusCode = httpUrlResponse.statusCode
                    switch statusCode {
                    case 200:
                        do {
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(Movies.self, from: data)
                            let movies = response.listOfMovies
                            observer.onNext(movies)
                        } catch _ {
                            observer.onError(NetworkErrors.decodingJSONError)
                        }
                        break
                    case 401:
                        observer.onError(NetworkErrors.statusCode401UnauthorizedError)
                        break
                    case 403:
                        observer.onError(NetworkErrors.statusCode403ForbiddenError)
                        break
                    case 404:
                        observer.onError(NetworkErrors.statusCode404NotFoundError)
                        break
                    default:
                        observer.onError(NetworkErrors.statusCodeGenericError)
                        break
                    }
                    return
                } else {
                    observer.onError(NetworkErrors.unknownError)
                    return
                }
                
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
        
    }
    
}
