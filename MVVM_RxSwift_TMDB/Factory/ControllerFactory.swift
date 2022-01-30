//
//  ControllerFactory.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 27/1/22.
//

import Foundation
import UIKit

class ControllerFactory {
    
    static let shared : ControllerFactory = {
        let instance = ControllerFactory()
        return instance
    }()
    
    func getUISearchController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        
        controller.hidesNavigationBarDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.barStyle = .black
        controller.searchBar.backgroundColor = .clear
        controller.searchBar.placeholder = Constants.Views.HomeView.SearchBarController.placeholderString
        
        return controller
    }
}
