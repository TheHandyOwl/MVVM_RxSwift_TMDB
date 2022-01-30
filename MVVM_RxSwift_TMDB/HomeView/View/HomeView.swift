//
//  HomeView.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import UIKit
import RxCocoa
import RxSwift


// MARK: HomeViewImageProtocol
protocol HomeViewImageProtocol: AnyObject {
    func getMovieImage(imageString: String) -> Observable<UIImage>?
}


// MARK: HomeViewProtocol
protocol HomeViewProtocol : AnyObject {
    var viewModel: HomeViewModelInputProtocol? { get set }
    
    func setupUI(appTitle: String)
}


// MARK: HomeView
class HomeView: UIViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var moviesTable: UITableView!
    
    var viewModel: HomeViewModelInputProtocol?
    
    private let disposeBag = DisposeBag()
    private var filteredMoviesArray : [Movie] = []
    private var moviesArray : [Movie] = []
    
    
    // MARK: lazy searchController
    lazy private var searchController: UISearchController = {
        ControllerFactory.shared.getUISearchController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        viewModel?.viewDidLoad()
        DispatchQueue.global().async {
            self.getData()
        }
    }
    
    private func getData() {
        startLoading()
        
        viewModel?.getPopularMovies()?
            .subscribe(onNext: { [weak self] movies in
                self?.moviesArray = movies
                DispatchQueue.main.async {
                    self?.moviesTable.reloadData()
                }
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            }, onCompleted: { [weak self] in
                self?.stopLoading()
            }).disposed(by: disposeBag)
        
    }
    
    private func managerSearchBarController() {
        searchController.delegate = self
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        
        searchBar.rx.text
            //.observe(on: MainScheduler.instance)
            //.subscribe(on: MainScheduler.instance)
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { movieString in
                self.filteredMoviesArray = self.moviesArray
                    .filter { movie in
                        movie.title.lowercased().range(of: movieString.lowercased()) != nil
                    }
                DispatchQueue.main.async {
                    self.moviesTable.reloadData()
                }
            }).disposed(by: disposeBag)
        
        
        moviesTable.tableHeaderView = searchBar
        moviesTable.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
    }
    
    private func registerCell() {
        let nib = UINib(nibName: Constants.Views.CustomMovieCell.nibName, bundle: Bundle.main)
        moviesTable.register(nib, forCellReuseIdentifier: Constants.Views.CustomMovieCell.cellID)
        moviesTable.rowHeight = UITableView.automaticDimension
    }
    
    private func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = false
            self?.activityIndicator.startAnimating()
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.hidesWhenStopped = true
        }
    }
    
}


// MARK: Extension - HomeViewImageProtocol
extension HomeView: HomeViewImageProtocol {
    func getMovieImage(imageString: String) -> Observable<UIImage>? {
        return viewModel?.getMovieImage(imageString: imageString)
    }
}


// MARK: Extension - HomeViewProtocol
extension HomeView: HomeViewProtocol {
    func setupUI(appTitle: String) {
        self.title = appTitle
        managerSearchBarController()
    }
}


// MARK: Extension - UISearchBarDelegate
extension HomeView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        DispatchQueue.main.async {
            self.moviesTable.reloadData()
        }
    }
}


// MARK: Extension - UISearchControllerDelegate
extension HomeView: UISearchControllerDelegate {
}


// MARK: Extension - UITableViewDataSource
extension HomeView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive && searchController.searchBar.text != "" ? filteredMoviesArray.count : moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cellID = Constants.Views.CustomMovieCell.cellID
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CustomMovieCell
        
        guard let cell = cell else { return UITableViewCell() }
        
        let item = searchController.isActive && searchController.searchBar.text != "" ? filteredMoviesArray[row] : moviesArray[row]
        cell.configureCell(mainView: self, movie: item)
        
        return cell
    }
    
}


// MARK: Extension - UITableViewDelegate
extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let item = searchController.isActive && searchController.searchBar.text != "" ? filteredMoviesArray[row] : moviesArray[row]
        let movieID = String(item.movieID)
        
        viewModel?.goToMovieDetail(movieID: movieID)
    }
}
