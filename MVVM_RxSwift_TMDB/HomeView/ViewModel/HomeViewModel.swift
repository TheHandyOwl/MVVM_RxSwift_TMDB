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
    var moviesArray : [Movie] { get set }
    var refreshMovieTable : (() -> ())? { get set }
    var router : HomeRouterProtocol? { get set }
    var view : HomeViewProtocol? { get set }
    
    
    func getMovieImage(imageString: String, success: @escaping (UIImage) -> ())
    func viewDidLoad()
}


// MARK: HomeViewModel
class HomeViewModel {
    
    private var filteredMoviesArray : [Movie] = []
    var moviesArray : [Movie] = [] {
        didSet {
            refreshMovieTable?()
        }
    }
    
    var refreshMovieTable : (() -> ())? = nil
    var router : HomeRouterProtocol?
    weak var view : HomeViewProtocol?
    
    private let disposeBag = DisposeBag()
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
    
    private func getPopularMoviesWithRxSwift() {
        DispatchQueue.global().async {
            ManagerConnections.shared.getPopularMovies()
            
            // Manejar la concurrencia o hilos de RxSwift
                .subscribe(on: MainScheduler.instance) // Trabajar en el hilo principal
            
            // Suscribirnos al observable
                .observe(on: MainScheduler.instance) // Suscribirnos en el hilo principal
            
            // Dar por completada la secuencia de RxSwift
                .subscribe(onNext: { [weak self] movies in
                    self?.moviesArray = movies
                }, onError: { [weak self] error in
                    self?.moviesArray = []
                    print("Error: \(error.localizedDescription)")
                }, onCompleted: {
                    // Nothing
                }).disposed(by: self.disposeBag)
            self.view?.stopLoading()
        }
    }
    
}


// MARK: Extension - HomeViewModelInputProtocol
extension HomeViewModel: HomeViewModelInputProtocol {
    
    func getMovieImage(imageString: String, success: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async {
            ManagerConnections.shared.getMovieImage(imageString: imageString)
                .observe(on: MainScheduler.instance)
                .subscribe(on: MainScheduler.instance)
                .subscribe { image in
                    success(image)
                } onError: { error in
                    print("Error: \(error)")
                } onCompleted: {
                    // Nothing
                }.disposed(by: self.disposeBag)

        }
    }
    
    func viewDidLoad() {
        view?.setupUI()
        view?.startLoading()
        //getMovies()
        getPopularMoviesWithRxSwift()
    }
    
}
