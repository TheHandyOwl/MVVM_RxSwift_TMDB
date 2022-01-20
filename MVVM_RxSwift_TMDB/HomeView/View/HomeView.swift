//
//  HomeView.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import UIKit


// MARK: HomeViewProtocol
protocol HomeViewProtocol : AnyObject {
    var viewModel: HomeViewModelInputProtocol? { get set }
    
    func setupUI()
    func startLoading()
    func stopLoading()
}


// MARK: HomeView
class HomeView: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var moviesTable: UITableView!
    
    var viewModel: HomeViewModelInputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.refreshMovieTable = {
            DispatchQueue.main.async { [weak self] in
                self?.moviesTable.reloadData()
            }
        }
        viewModel?.viewDidLoad()
    }
    
}


// MARK: Extension - HomeViewProtocol
extension HomeView: HomeViewProtocol {
    
    func setupUI() {
        title = Constants.App.name
    }
    
    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = false
            self?.activityIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.hidesWhenStopped = true
        }
    }
    
}


// MARK: Extension - UITableViewDataSource
extension HomeView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.moviesArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellID")
        
        let row = indexPath.row
        if let item = viewModel?.moviesArray[row] {
            var content = cell.defaultContentConfiguration()
            content.text = "Título: \(item)"
            content.secondaryText = "Subtítulo: \(item)"
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
}



// MARK: Extension - UITableViewDelegate
extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        let row = indexPath.row
        let item = viewModel.moviesArray[row]
        
        print("Item: \(item)")
    }
}
