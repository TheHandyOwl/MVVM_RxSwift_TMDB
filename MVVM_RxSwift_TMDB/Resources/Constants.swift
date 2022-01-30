//
//  Constants.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import Foundation

struct Constants {
    
    struct App {
        static let name = "The movies App"
    }
    
    struct API {
        static let apiKeyBridge = "?api_key="
        static let apiKeyValue = "d535b316cd84b2899e503444201247c1"
        
        struct URL {
            static let urlMainSite = "https://api.themoviedb.org/"
            static let urlMainImagesW200 = "https://image.tmdb.org/t/p/w200/"
        }
        
        struct Endpoints {
            static let urlEndpointListMovies = "3/movie/popular"
            static let urlEndpointDetailMovie = "3/movie/"
        }
        
        struct Params {
            static let paramPage = "&page="
        }
    }
    
    struct Views {
        
        struct CustomMovieCell {
            
            static let cellID = "CustomMovieCellID"
            static let nibName = "CustomMovieCell"
            
            struct Strings {
                static let description = "description..."
                static let moviePlaceholderImage = "xmark.octagon.fill"
                static var title = "title..."
            }
            
        }
        
        struct HomeView {
            static let nibName = "HomeView"
            struct SearchBarController {
                static let placeholderString = "Buscar una película"
            }
        }
        
        struct DetailView {
            static let nibName = "DetailView"
        }
        
    }
    
}
