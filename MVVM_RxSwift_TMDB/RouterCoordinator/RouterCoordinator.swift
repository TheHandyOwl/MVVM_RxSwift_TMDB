//
//  RouterCoordinator.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 24/2/22.
//

import UIKit


// MARK: RouterCoordinatorProtocol
protocol RouterCoordinatorProtocol {
    var navigationController : UINavigationController { get set }
    
    func goToDetailView(movieID: String)
    func start()
}


// MARK: - RouterCoordinator
class RouterCoordinator : RouterCoordinatorProtocol {
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func goToDetailView(movieID: String) {
        let view = DetailView(nibName: "DetailView", bundle: Bundle.main)
        
        let repository: DetailRepositoryProtocol = DetailRepository()
        //let router : RouterCoordinatorProtocol = self
        let viewModel : DetailViewModelInputProtocol = DetailViewModel()
        
        viewModel.repository = repository
        //viewModel.router = router
        viewModel.view = view
        view.viewModel = viewModel
        
        view.movieID = movieID
        
        navigationController.pushViewController(view, animated: true)
    }

    func start() {
        let view = HomeView(nibName: Constants.Views.HomeView.nibName, bundle: Bundle.main)
        
        let repository : HomeRepositoryProtocol = HomeRepository()
        let router : RouterCoordinatorProtocol = self
        let viewModel : HomeViewModelInputProtocol = HomeViewModel()
        
        viewModel.repository = repository
        viewModel.router = router
        viewModel.view = view
        view.viewModel = viewModel
        
        
        navigationController.pushViewController(view, animated: true)
    }
    
}
