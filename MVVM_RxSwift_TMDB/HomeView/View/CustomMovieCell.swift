//
//  CustomMovieCell.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 22/1/22.
//

import UIKit
import RxSwift

class CustomMovieCell: UITableViewCell {
    
    @IBOutlet weak private var movieImage: UIImageView!
    @IBOutlet weak private var movieTitleLabel: UILabel!
    @IBOutlet weak private var movieDescriptionLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        movieImage.image = UIImage(systemName: Constants.Views.CustomMovieCell.Strings.moviePlaceholderImage)
        movieTitleLabel.text = Constants.Views.CustomMovieCell.Strings.title.capitalizingFirstLetter()
        movieDescriptionLabel.text = Constants.Views.CustomMovieCell.Strings.description.capitalizingFirstLetter()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(mainView: HomeViewImageProtocol, movie: Movie) {
        movieTitleLabel.text = movie.title
        movieDescriptionLabel.text = movie.sinopsis
        
        mainView.getMovieImage(imageString: movie.image)?
            .observe(on: MainScheduler.instance)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                DispatchQueue.main.async {
                    self?.movieImage.image = image
                }
            }).disposed(by: disposeBag)
    }
    
}
