//
//  ViewModelCharacterList.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 27/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class CharacterListViewModel {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    let urlSession: URLSession
    private let controller: BaseControllerProtocol
    var refreshData = { () -> () in }
    var arrayCharacters: [Character] = [] {
        didSet { refreshData() }
    }
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    init(controller: BaseControllerProtocol,
         urlSession: URLSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)) {
        self.controller = controller
        self.urlSession = urlSession
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func wsGetCharacterList() {
        MarvelNetwork.executeRequest(endpoint: MarvelComicsEndpoint.wsGetCharacters(params: CharacterListDTO(limit: 50)),
                                     model: WSCharactersResponse.self, session: urlSession) { result in
            switch result {
            case .success(let response):
                self.arrayCharacters = response.data?.results ?? []
                if self.arrayCharacters.isEmpty {
                    self.controller.showView(type: .viewError, mssgError: "No se han encontrado valores")
                } else {
                    self.controller.showView(type: .viewContent, mssgError: nil)
                }
            case .failure(let error):
                self.arrayCharacters = []
                self.controller.showView(type: .viewError, mssgError: error.description)
            }
        }
    }
    
}
