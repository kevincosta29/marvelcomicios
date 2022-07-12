//
//  CharacterDetailDataSource.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation

class CharacterDetailDataSource: CharacterDetailDataSourceProtocol {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    private let session: URLSession
    
    //-----------------------
    // MARK: - INIT
    //-----------------------
    
    init(session: URLSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)) {
        self.session = session
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func getComics(id: Int, completion: @escaping (Result<[Comic], KNetworkError>) -> Void) {
        MarvelNetwork.executeRequest(endpoint: MarvelComicsEndpoint.wsGetCharacterComics(id: id),
                                 model: WSComicsResponse.self, session: session) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data?.results ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSeries(id: Int, completion: @escaping (Result<[Serie], KNetworkError>) -> Void) {
        MarvelNetwork.executeRequest(endpoint: MarvelComicsEndpoint.wsGetCharacterSeries(id: id),
                                 model: WSSeriesResponse.self, session: session) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data?.results ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
