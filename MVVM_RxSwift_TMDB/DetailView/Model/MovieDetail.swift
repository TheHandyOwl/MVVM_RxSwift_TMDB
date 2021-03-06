//
//  MovieDetail.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 30/1/22.
//

import Foundation

struct MovieDetail: Codable {
    let image: String
    let movieID: Int
    let originalTitle: String
    let releaseDate: String
    let synopsis: String
    let title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
        case movieID = "id"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case synopsis = "overview"
        case title
        case voteAverage = "vote_average"
    }
}
