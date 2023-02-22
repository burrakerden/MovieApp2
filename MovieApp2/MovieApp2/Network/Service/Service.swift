//
//  Service.swift
//  MovieApp2
//
//  Created by Burak Erden on 21.02.2023.
//

import Alamofire

protocol ServiceProtocol {
    func getMovie(page: Int, searchText: String, onSuccess: @escaping (MovieApi?) -> Void, onError: @escaping (AFError) -> Void)
}

final class Service: ServiceProtocol {
    func getMovie(page: Int, searchText: String, onSuccess: @escaping (MovieApi?) -> Void, onError: @escaping (Alamofire.AFError) -> Void) {
        ServiceManager.shared.fetch(path: "https://www.omdbapi.com/?apikey=3679eed8&s=\(searchText)&page=\(page)") { (response: MovieApi) in
            onSuccess(response)
        } onError: { (error) in
            onError(error)
        }
    }
}
