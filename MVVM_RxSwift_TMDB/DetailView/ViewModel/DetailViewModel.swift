//
//  DetailViewModel.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 30/1/22.
//

import Foundation
import RxSwift


// MARK: DetailViewModelInputProtocol
protocol DetailViewModelInputProtocol : AnyObject {
    var repository : DetailRepositoryProtocol? { get set }
    var router : RouterCoordinatorProtocol? { get set }
    var view : DetailViewProtocol? { get set }
    
    func getMovieImage(imageString: String) -> Observable<UIImage>?
    func getMovieDetail(movieID: String) -> Observable<MovieDetail>?
    func viewDidLoad(movieID: String)
}


// MARK: DetailViewModel & DetailViewModelInputProtocol Extension
class DetailViewModel: DetailViewModelInputProtocol {

    var repository : DetailRepositoryProtocol?
    var router : RouterCoordinatorProtocol?
    weak var view : DetailViewProtocol?
    
    func getMovieImage(imageString: String) -> Observable<UIImage>? {
        return repository?.getMovieImage(imageString: imageString)
    }
    
    func getMovieDetail(movieID: String) -> Observable<MovieDetail>? {
        return repository?.getMovieDetail(movieID: movieID)
    }
    
    func viewDidLoad(movieID: String) {
        let movieTitle = "Loading data ..."
        view?.setupUI(movieTitle: movieTitle, movieID: movieID)
    }
    
}
