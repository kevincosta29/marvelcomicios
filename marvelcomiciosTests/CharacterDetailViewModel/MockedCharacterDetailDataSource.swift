//
//  MockedCharacterDetailDataSource.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 13/8/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation
import KNetwork
@testable import marvelcomicios

class MockedCharacterDetailDataSource: CharacterDetailDataSourceProtocol {
    
    var resultComics: (Result<[Comic], KNetworkError>)?
    var resultSeries: (Result<[Serie], KNetworkError>)?
    
    func getComics(id: Int) async -> (Result<[Comic], KNetworkError>) {
        guard resultComics != nil else {
            return .failure(.error(message: "FAIL"))
        }
        return resultComics!
    }
    
    func getSeries(id: Int) async -> (Result<[Serie], KNetworkError>) {
        guard resultSeries != nil else {
            return .failure(.error(message: "FAIL"))
        }
        return resultSeries!
    }
    
}
