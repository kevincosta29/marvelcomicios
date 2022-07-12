//
//  CharacterDetailDataSourceProtocol.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation

protocol CharacterDetailDataSourceProtocol {
    func getComics(id: Int, completion: @escaping (Result<[Comic], KNetworkError>) -> Void)
    func getSeries(id: Int, completion: @escaping (Result<[Serie], KNetworkError>) -> Void)
}
