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
    
    private var urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    private var controller: BaseControllerProtocol!
    var refreshData = { () -> () in }
    var arrayCharacters: [Character] = [] {
        didSet { refreshData() }
    }
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    init(controller: BaseControllerProtocol) {
        self.controller = controller
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
                self.controller.showView(type: .viewError, mssgError: error.description)
            }
        }
    }
    
}
