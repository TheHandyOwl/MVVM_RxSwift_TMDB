//
//  HomeViewModel.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import Foundation


// MARK: HomeViewModelInputProtocol
protocol HomeViewModelInputProtocol : AnyObject {
    var moviesArray : [String] { get set }
    var refreshMovieTable : (() -> ())? { get set }
    var router : HomeRouterProtocol? { get set }
    var view : HomeViewProtocol? { get set }
    
    func viewDidLoad()
}


// MARK: HomeViewModel
class HomeViewModel: HomeViewModelInputProtocol {
    
    weak var view : HomeViewProtocol?
    var router : HomeRouterProtocol?
    
    var refreshMovieTable : (() -> ())? = nil
    
    var moviesArray : [String] = [] {
        didSet {
            refreshMovieTable?()
        }
    }
    
    func viewDidLoad() {
        moviesArray =  ["First movie", "Second movie"]
        view?.setupUI()
        view?.startLoading()
        DispatchQueue.global().async { [weak self] in
            sleep(2)
            self?.moviesArray =  ["First movie", "Second movie", "Third movie", "Fourth movie"]
            self?.view?.stopLoading()
        }
    }
    
}
