//
//  StringExtension.swift
//  MVVM_RxSwift_TMDB
//
//  Created by Carlos on 22/1/22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
