//
//  DetailView.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 19/1/22.
//

import UIKit
import RxSwift


// MARK: DetailViewProtocol
protocol DetailViewProtocol : AnyObject {
    var movieID: String? { get set }
    var viewModel: DetailViewModelInputProtocol? { get set }
    
    func setupUI(movieTitle: String, movieID: String)
}


// MARK: HomeView
class DetailView: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var synopsisLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    @IBOutlet private weak var originalTitleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    var viewModel: DetailViewModelInputProtocol?
    var movieID: String?
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movieID = movieID else { return }
        viewModel?.viewDidLoad(movieID: movieID)
    }
    
    private func getMovieDetail(movieID: String) {
        viewModel?.getMovieDetail(movieID: movieID)?
            .subscribe(
                onNext: { movieDetail in
                    //print("movieDetail: \(movieDetail)")
                    self.refreshMovieDetail(movieDetail: movieDetail)
                },
                onError: { error in
                    print("Error: \(error.localizedDescription)")
                },
                onCompleted: {
                    //print("Movie loaded")
                },
                onDisposed: {
                }).disposed(by: disposeBag)
    }
    
    private func refreshMovieDetail(movieDetail: MovieDetail) {
        DispatchQueue.main.async {
            self.title = movieDetail.title
            
            self.titleLabel.text = movieDetail.title
            self.synopsisLabel.text = movieDetail.synopsis
            self.releaseLabel.text = movieDetail.releaseDate
            self.originalTitleLabel.text = movieDetail.originalTitle
            self.ratingLabel.text = "\(movieDetail.voteAverage)"
            
            self.posterImage.image = UIImage(systemName: Constants.Views.CustomMovieCell.Strings.moviePlaceholderImage)
            DispatchQueue.global().async {
                self.viewModel?.getMovieImage(imageString: movieDetail.image)?
                    .subscribe(onNext: { image in
                        DispatchQueue.main.async {
                            self.posterImage.image = image
                        }
                    }, onError: { error in
                        print("Error: \(error.localizedDescription)")
                    }, onCompleted: {
                        //print("Image loaded")
                    }, onDisposed: {
                    }).disposed(by: self.disposeBag)
            }
            
        }
    }
    
}


// MARK: Extension DetailViewProtocol
extension DetailView: DetailViewProtocol {
    func setupUI(movieTitle: String, movieID: String) {
        DispatchQueue.main.async {
            self.title = movieTitle
            self.getMovieDetail(movieID: movieID)
        }
    }
}
