//
//  ViewModel.swift
//  MovieApp2
//
//  Created by Burak Erden on 21.02.2023.
//

import Foundation
import UIKit
import Alamofire

class ViewModel {
    
    var movieData: [Search]?
    
    //MARK: - GET DATA
    
    func getMovieData(searchText: String) {
        Service().getMovie(searchText: searchText){ result in
            guard let data = result?.search else {return}
            self.movieData = data
            print(data)
        } onError: { error in
            print(error)
        }
    }
}
