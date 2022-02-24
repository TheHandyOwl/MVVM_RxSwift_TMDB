//
//  HomeViewModel.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import Foundation
import RxSwift


// MARK: HomeViewModelInputProtocol
protocol HomeViewModelInputProtocol : AnyObject {
    var repository : HomeRepositoryProtocol? { get set }
    var router : RouterCoordinatorProtocol? { get set }
    var view : HomeViewProtocol? { get set }
    
    func getMovieImage(imageString: String) -> Observable<UIImage>?
    func getPopularMovies() -> Observable<[Movie]>?
    func goToMovieDetail(movieID: String)
    func viewDidLoad()
}


// MARK: HomeViewModel & HomeViewModelInputProtocol Extension
class HomeViewModel: HomeViewModelInputProtocol {

    var repository : HomeRepositoryProtocol?
    var router : RouterCoordinatorProtocol?
    weak var view : HomeViewProtocol?
    
    func getMovieImage(imageString: String) -> Observable<UIImage>? {
        return repository?.getMovieImage(imageString: imageString)
    }
    
    func getPopularMovies() -> Observable<[Movie]>? {
        return repository?.getPopularMovies()
    }
    
    func goToMovieDetail(movieID: String) {
        router?.goToDetailView(movieID: movieID)
    }
    
    func viewDidLoad() {
        let appTitle = Constants.App.name
        view?.setupUI(appTitle: appTitle)
    }
    
}
