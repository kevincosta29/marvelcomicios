//
//  CharacterListDataSourceProtocol.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation

protocol CharacterListDataSourceProtocol {
    func getCharacterList(completion: @escaping (Result<[Character], KNetworkError>) -> Void)
}
