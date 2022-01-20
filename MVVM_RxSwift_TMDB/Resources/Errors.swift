//
//  Errors.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 20/1/22.
//

import Foundation

enum NetworkErrors: Error {
    case decodingJSONError
    case statusCode401UnauthorizedError
    case statusCode403ForbiddenError
    case statusCode404NotFoundError
    case statusCodeGenericError
    case unknownError
}
