//
//  CharacterListViewModelProtocol.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation

protocol CharacterListViewModelProtocol {
    
    var arrayCharacter: [Character] { get set }
    var refreshData: (() -> Void)? { get set }
    var showView: ((ViewType, String?) ->Void)? { get set }
    
    func retrieveCharacterList(showLoading: Bool)
    
}
