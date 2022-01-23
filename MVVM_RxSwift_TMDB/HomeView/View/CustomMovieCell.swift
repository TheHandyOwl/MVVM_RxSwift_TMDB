//
//  CustomMovieCell.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 22/1/22.
//

import UIKit

class CustomMovieCell: UITableViewCell {

    @IBOutlet weak private var movieImage: UIImageView!
    @IBOutlet weak private var movieTitleLabel: UILabel!
    @IBOutlet weak private var movieDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImage.image = UIImage(systemName: Constants.Views.CustomMovieCell.Strings.moviePlaceholderImage)
        movieTitleLabel.text = Constants.Views.CustomMovieCell.Strings.title.capitalizingFirstLetter()
        movieDescriptionLabel.text = Constants.Views.CustomMovieCell.Strings.description.capitalizingFirstLetter()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel: HomeViewModelInputProtocol, movie: Movie) {
        movieTitleLabel.text = movie.title
        movieDescriptionLabel.text = movie.sinopsis
        
        viewModel.getMovieImage(imageString: movie.image) { [weak self] image in
            DispatchQueue.main.async {
                self?.movieImage.image = image
                //self?.movieImage.changeImageWithFadeEffect(with: image)
            }
        }
    }
    
}
