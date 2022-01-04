//
//  CharacterDetailViewModel.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import Alamofire

class CharacterDetailViewModel {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    private var urlSession: URLSession
    private var controller: BaseControllerProtocol
    var refreshData = { () -> () in }
    var arrayComics: [Comic] = []
    var arraySeries: [Serie] = []
    var arraySections: [CharacterDetailSection] = []
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    init(controller: BaseControllerProtocol,
         session: URLSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)) {
        self.controller = controller
        self.urlSession = session
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func wsGetComics(id: Int) {
        MarvelNetwork.executeRequest(endpoint: MarvelComicsEndpoint.wsGetCharacterComics(id: id),
                                 model: WSComicsResponse.self, session: urlSession) { result in
            switch result {
            case .success(let response):
                self.arrayComics = response.data?.results ?? []
                self.createContent()
            case .failure(_):
                self.arrayComics = []
                self.createContent()
            }
        }
    }
    
    func wsGetSeries(id: Int) {
        MarvelNetwork.executeRequest(endpoint: MarvelComicsEndpoint.wsGetCharacterSeries(id: id),
                                 model: WSSeriesResponse.self, session: urlSession) { result in
            switch result {
            case .success(let response):
                self.arraySeries = response.data?.results ?? []
                self.createContent()
            case .failure(_):
                self.arraySeries = []
                self.createContent()
            }
        }
    }
    
    private func createContent() {
        arraySections = [.header]
        
        if !arrayComics.isEmpty {
            arraySections.append(.comics)
        }
        
        if !arraySeries.isEmpty {
            arraySections.append(.series)
        }
        
        refreshData()
        controller.showView(type: .viewContent, mssgError: nil)
    }
    
}
