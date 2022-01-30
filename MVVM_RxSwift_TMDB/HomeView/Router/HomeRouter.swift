//
//  HomeRouter.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import Foundation
import UIKit


// MARK: HomeRouterProtocol
protocol HomeRouterProtocol : AnyObject {
    var viewController : UIViewController { get }
    
    func goToMovieDetail(view: HomeViewProtocol, movieID: String)
}


// MARK: HomeRouter
class HomeRouter: HomeRouterProtocol {
    
    var viewController : UIViewController {
        return createViewController()
    }
    
    private func createViewController() -> UIViewController {
        let view = HomeView(nibName: Constants.Views.HomeView.nibName, bundle: Bundle.main)
        
        let repository : HomeRepositoryProtocol = HomeRepository()
        let router : HomeRouterProtocol = HomeRouter()
        let viewModel : HomeViewModelInputProtocol = HomeViewModel()
        
        view.viewModel = viewModel
        viewModel.repository = repository
        viewModel.router = router
        viewModel.view = view
        
        return view
    }
    
    func goToMovieDetail(view: HomeViewProtocol, movieID: String) {
        guard let oldView = view as? UIViewController else { return }
        let newView = DetailRouter.createViewController(movieID: movieID)
        
        oldView.navigationController?.pushViewController(newView, animated: true)
        
    }
    
}
