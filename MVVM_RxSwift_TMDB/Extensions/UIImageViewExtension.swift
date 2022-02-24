//
//  UIImageViewExtension.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 23/1/22.
//

import Foundation
import UIKit

extension UIImageView {
    
    /*
    func changeImageWithFadeEffect(with newImage: UIImage) {
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.image = newImage },
                          completion: nil)
    }
     */
    
    /*
    func loadImage(urlString: String, placeholderImage: String) {
        self.image = UIImage(systemName: placeholderImage)
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: URL(string: urlString)!) { data, _, error in
                guard error == nil, let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.image = image
                }
            }.resume()
        }
    }
     */
    
}
