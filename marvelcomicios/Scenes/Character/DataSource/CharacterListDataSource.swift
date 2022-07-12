//
//  CharacterListDataSource.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation

class CharacterListDataSource: CharacterListDataSourceProtocol {
    
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
    
    func getCharacterList(completion: @escaping (Result<[Character], KNetworkError>) -> Void) {
        MarvelNetwork.executeRequest(endpoint: MarvelComicsEndpoint.wsGetCharacters(params: CharacterListDTO(limit: 50)),
                                     model: WSCharactersResponse.self, session: session) { result in
            switch result {
            case .success(let response):
                if let arrayCharacters = response.data?.results, !arrayCharacters.isEmpty {
                    completion(.success(arrayCharacters))
                } else {
                    completion(.failure(KNetworkError.error(message: "No se han encontrado valores")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
