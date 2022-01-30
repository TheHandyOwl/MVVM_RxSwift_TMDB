//
//  DetailRouter.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 30/1/22.
//

import Foundation
import UIKit


// MARK: DetailRouterProtocol
protocol DetailRouterProtocol: AnyObject {
    static func createViewController(movieID: String) -> UIViewController
}


// MARK: DetailRouter
class DetailRouter: DetailRouterProtocol {
    
    private static var detailView: UIViewController {
        let view = DetailView(nibName: "DetailView", bundle: Bundle.main)
        return view
    }
    
    static func createViewController(movieID: String) -> UIViewController {
        
        if let view = detailView as? DetailView {
            let repository: DetailRepositoryProtocol = DetailRepository()
            let router : DetailRouterProtocol = DetailRouter()
            let viewModel : DetailViewModelInputProtocol = DetailViewModel()
            
            viewModel.repository = repository
            viewModel.router = router
            viewModel.view = view
            view.viewModel = viewModel
            
            view.movieID = movieID
            
            return view
        }
        
        return UIViewController()
    }
    
}
