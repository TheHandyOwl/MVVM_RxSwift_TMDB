//
//  ManagerConnections.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 20/1/22.
//

import Foundation

class ManagerConnections {
    
    static var shared : ManagerConnections {
        let instance = ManagerConnections()
        return instance
    }
    
    func fetchData(urlString: String, success: @escaping (Data)->(), failure: @escaping (Error)->()) {
        
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if (data == nil), error != nil {
                failure(NetworkErrors.unknownError)
                return
            }
            
            if let data = data, let httpUrlResponse = response as? HTTPURLResponse {
                let statusCode = httpUrlResponse.statusCode
                switch statusCode {
                case 200:
                    success(data)
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
    
}
