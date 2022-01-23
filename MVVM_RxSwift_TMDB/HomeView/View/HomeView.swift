//
//  HomeView.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import UIKit
import RxSwift


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
        
        registerCell()
        
        viewModel?.refreshMovieTable = {
            DispatchQueue.main.async { [weak self] in
                self?.moviesTable.reloadData()
            }
        }
        viewModel?.viewDidLoad()
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "CustomMovieCell", bundle: Bundle.main)
        moviesTable.register(nib, forCellReuseIdentifier: "CustomMovieCellID")
        moviesTable.rowHeight = UITableView.automaticDimension
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cellID = Constants.Views.CustomMovieCell.cellID
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CustomMovieCell
        
        guard let cell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let item = viewModel.moviesArray[row]
        cell.configureCell(viewModel: viewModel, movie: item)
        
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
