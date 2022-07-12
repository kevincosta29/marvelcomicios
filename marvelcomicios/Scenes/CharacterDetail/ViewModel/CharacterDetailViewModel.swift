//
//  CharacterDetailViewModel.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import Alamofire

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
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
    
    func retrieveContent(id: Int) {
        createContent()
        
        dataSource.getComics(id: id) { [weak self] result in
            switch result {
            case .success(let array):
                self?.arrayComics = array
                self?.createContent()
            case .failure(let error):
                print(error.description)
            }
        }
        
        dataSource.getSeries(id: id) { [weak self] result in
            switch result {
            case .success(let array):
                self?.arraySeries = array
                self?.createContent()
            case .failure(let error):
                print(error.description)
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
    }
    
}
