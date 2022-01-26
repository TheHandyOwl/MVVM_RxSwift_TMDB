//
//  HomeView.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import UIKit
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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var moviesTable: UITableView!
    
    var viewModel: HomeViewModelInputProtocol?
    
    private let disposeBag = DisposeBag()
    private var filteredMoviesArray : [Movie] = []
    private var moviesArray : [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        viewModel?.viewDidLoad()
        getData()
    }
    
    private func getData() {
        startLoading()
        
        viewModel?.getPopularMovies()?
            .subscribe(onNext: { [weak self] movies in
                self?.moviesArray = movies
                self?.moviesTable.reloadData()
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            }, onCompleted: { [weak self] in
                self?.stopLoading()
            }).disposed(by: disposeBag)
        
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "CustomMovieCell", bundle: Bundle.main)
        moviesTable.register(nib, forCellReuseIdentifier: "CustomMovieCellID")
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
    }
}


// MARK: Extension - UITableViewDataSource
extension HomeView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cellID = Constants.Views.CustomMovieCell.cellID
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CustomMovieCell
        
        guard let cell = cell else { return UITableViewCell() }
        
        let item = moviesArray[row]
        cell.configureCell(mainView: self, movie: item)
        
        return cell
    }
    
}


// MARK: Extension - UITableViewDelegate
extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let item = moviesArray[row]
        
        print("Item: \(item)")
    }
}
