//
//  CharacterListDataSourceProtocol.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation
import KNetwork

protocol CharacterListDataSourceProtocol {
    func getCharacterList() async -> (Result<[Character], KNetworkError>)
}
