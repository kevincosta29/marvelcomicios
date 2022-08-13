//
//  CharacterDetailDataSource.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation
import KNetwork

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
    
    func getComics(id: Int) async -> (Result<[Comic], KNetworkError>) {
        let endPoint = MarvelComicsEndpoint.wsGetCharacterComics(id: id)
        let response = await Service.executeRequest(endpoint: endPoint, model: WSComicsResponse.self, session: session)
        
        switch response {
        case .success(let response):
            return .success(response.data?.results ?? [])
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getSeries(id: Int) async -> (Result<[Serie], KNetworkError>) {
        let endPoint = MarvelComicsEndpoint.wsGetCharacterSeries(id: id)
        let response = await Service.executeRequest(endpoint: endPoint, model: WSSeriesResponse.self, session: session)
        
        switch response {
        case .success(let response):
            return .success(response.data?.results ?? [])
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
