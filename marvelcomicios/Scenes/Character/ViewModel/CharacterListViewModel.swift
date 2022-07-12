//
//  ViewModelCharacterList.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 27/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation

class CharacterListViewModel: CharacterListViewModelProtocol {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    var refreshData: (() -> Void)?
    var arrayCharacter: [Character] = []
    var showView: ((ViewType, String?) -> Void)?
    private let dataSource: CharacterListDataSourceProtocol
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    init(dataSource: CharacterListDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func retrieveCharacterList(showLoading: Bool) {
        if showLoading {
            self.showView?(.viewLoading, nil)
        }
        dataSource.getCharacterList { [weak self] result in
            switch result {
            case .success(let array):
                self?.arrayCharacter = array
                self?.refreshData?()
                self?.showView?(.viewContent, nil)
            case .failure(let error):
                self?.showView?(.viewError, error.description)
            }
        }
    }
    
}
