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
}


// MARK: HomeRouter
class HomeRouter: HomeRouterProtocol {
    
    var viewController : UIViewController {
        return createViewController()
    }
    
    private func createViewController() -> UIViewController {
        let view = HomeView(nibName: Constants.Views.HomeView.nibName, bundle: Bundle.main)
        
        let router : HomeRouterProtocol = HomeRouter()
        let viewModel : HomeViewModelInputProtocol = HomeViewModel()
        
        view.viewModel = viewModel
        viewModel.router = router
        viewModel.view = view
        
        return view
    }
    
}
