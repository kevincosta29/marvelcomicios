//
//  CharacterDetailDataSourceProtocol.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation
import KNetwork

protocol CharacterDetailDataSourceProtocol {
    func getComics(id: Int) async -> (Result<[Comic], KNetworkError>)
    func getSeries(id: Int) async -> (Result<[Serie], KNetworkError>)
}
