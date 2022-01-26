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
    
    func fetchData(urlString: String) -> Observable<Data> {
        
        return Observable.create { observer in
            let urlRequest = URLRequest(url: URL(string: urlString)!)
            
            let session = URLSession.shared
            session.dataTask(with: urlRequest) { data, response, error in
                if data == nil, error != nil {
                    observer.onError(NetworkErrors.unknownError)
                    observer.onCompleted()
                    return
                }
                
                if let data = data, let httpUrlResponse = response as? HTTPURLResponse {
                    let statusCode = httpUrlResponse.statusCode
                    switch statusCode {
                    case 200:
                        observer.onNext(data)
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
                } else {
                    observer.onError(NetworkErrors.unknownError)
                }
                
                observer.onCompleted()
                
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
            
        }
        
    }
        
}
