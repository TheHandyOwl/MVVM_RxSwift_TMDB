//
//  HomeViewModel.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import Foundation


// MARK: HomeViewModelInputProtocol
protocol HomeViewModelInputProtocol : AnyObject {
    var moviesArray : [Movie] { get set }
    var refreshMovieTable : (() -> ())? { get set }
    var router : HomeRouterProtocol? { get set }
    var view : HomeViewProtocol? { get set }
    
    func viewDidLoad()
}


// MARK: HomeViewModel
class HomeViewModel {
    
    var moviesArray : [Movie] = [] {
        didSet {
            refreshMovieTable?()
        }
    }
    
    var refreshMovieTable : (() -> ())? = nil
    var router : HomeRouterProtocol?
    weak var view : HomeViewProtocol?
    
    private let repository = PopularMoviesRepository()
    
    private func getMovies() {
        DispatchQueue.global().async { [weak self] in
            self?.repository.getPopularMovies { movies in
                self?.moviesArray = movies
            } failure: { error in
                print("Error: \(error.localizedDescription)")
            }
            self?.view?.stopLoading()
        }
    }
    
}


// MARK: Extension - HomeViewModelInputProtocol
extension HomeViewModel: HomeViewModelInputProtocol {
    func viewDidLoad() {
        view?.setupUI()
        view?.startLoading()
        getMovies()
    }
}
