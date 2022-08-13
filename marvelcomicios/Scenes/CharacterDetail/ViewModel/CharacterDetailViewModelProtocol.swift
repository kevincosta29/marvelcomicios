//
//  CharacterDetailViewModelProtocol.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation

protocol CharacterDetailViewModelProtocol {
    
    var arrayComics: [Comic] { get set }
    var arraySeries: [Serie] { get set }
    var arraySections: [CharacterDetailSection] { get set }
    var refreshData: (() -> Void) { get set }
    var showView: ((ViewType, String?) -> Void)? { get set }
    
    func retrieveSeries(id: Int)
    func retrieveComics(id: Int)
}
