//
//  CharacterDetailViewModel.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import KNetwork

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    var msgError: ((String?) -> Void)?
    var showView: ((ViewType, String?) -> Void)?
    var refreshData = { () -> () in }
    var arrayComics: [Comic] = []
    var arraySeries: [Serie] = []
    var arraySections: [CharacterDetailSection] = []
    private let dataSource: CharacterDetailDataSourceProtocol
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    init(dataSource: CharacterDetailDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func retrieveComics(id: Int) {
        Task {
            let responseComics = await dataSource.getComics(id: id)
            
            switch responseComics {
            case .success(let array):
                arrayComics = array
                createContent()
            case .failure(let error):
                showView?(.viewError, error.description)
            }
        }
    }
    
    func retrieveSeries(id: Int) {
        Task {
            let responseSeries = await dataSource.getSeries(id: id)
            switch responseSeries {
            case .success(let array):
                arraySeries = array
                createContent()
            case .failure(let error):
                showView?(.viewError, error.description)
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
        
        DispatchQueue.main.async {
            self.refreshData()
        }
    }
    
}
