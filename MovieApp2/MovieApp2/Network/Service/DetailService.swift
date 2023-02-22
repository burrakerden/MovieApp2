//
//  DetailService.swift
//  MovieApp2
//
//  Created by Burak Erden on 21.02.2023.
//

import Alamofire

protocol DetailServiceProtocol {
    func getMovieDetail(imdbID: String, onSuccess: @escaping (MovieDetailApi?) -> Void, onError: @escaping (AFError) -> Void)
}

final class DetailService: DetailServiceProtocol {
    func getMovieDetail(imdbID: String, onSuccess: @escaping (MovieDetailApi?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.fetch(path: "https://www.omdbapi.com/?apikey=3679eed8&i=\(imdbID)") { (response: MovieDetailApi) in
            onSuccess(response)
        } onError: { (error) in
            onError(error)
        }
    }
}

