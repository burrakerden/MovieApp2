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
    
    var movieData: (([Search]) -> Void)?
    var movieDetailData: ((MovieDetailApi) -> Void)?
    var checkMovieData: ((Bool?) -> Void)?
    
    //MARK: - GET DATA
    
    func getMovieData(searchText: String, page: Int) {
        Service().getMovie(page: page, searchText: searchText){ result in
            if result?.response == "True" {
                self.checkMovieData?(true)
                guard let data = result?.search else {return}
                self.movieData?(data)
            } else {
                self.checkMovieData?(false)
            }
        } onError: { error in
            print("ERROR: ", error.localizedDescription)
        }
            
    }

    func getDetailData(imdbID: String) {
        DetailService().getMovieDetail(imdbID: imdbID){ result in
            guard let data = result else {return}
            self.movieDetailData?(data)
        } onError: { error in
            print(error)
        }
    }
    
    func getPaginationData(searchText: String, page: Int) {
        Service().getMovie(page: page, searchText: searchText){ result in
                guard let data = result?.search else {return}
                self.movieData?(data)
        } onError: { error in
            print("ERROR: ", error.localizedDescription)
        }
            
    }
}
