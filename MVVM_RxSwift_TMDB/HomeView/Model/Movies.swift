//
//  Movies.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 20/1/22.
//

import Foundation


// MARK: - Movies
struct  Movies: Codable {
    
    let listOfMovies : [Movie]
    
    enum CodingKeys: String, CodingKey {
        case listOfMovies = "results"
    }
    
}


// MARK: - Movie
struct Movie: Codable {

    let image: String
    let movieID: Int
    let originalTitle: String
    let popularity: Double
    let releaseDate: String
    let sinopsis: String
    let title: String
    let voteCount: Int
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case image = "poster_path"
        case movieID = "id"
        case originalTitle = "original_title"
        case popularity
        case releaseDate = "release_date"
        case sinopsis = "overview"
        case title
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }

}


// MARK: - Movies - All properties
/*
struct Movies: Codable {
    let page: Int
    let results: [Result]
    let totalResults, totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

// MARK: Result
struct Result: Codable {
    let posterPath: String
    let adult: Bool
    let overview, releaseDate: String
    let genreIDS: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: OriginalLanguage
    let title, backdropPath: String
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case releaseDate = "release_date"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
}
*/
