//
//  CharacterListDTO.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//
import Foundation

struct CharacterListDTO: BaseProtocolDTO {
    var ts: String = ""
    var apikey: String = ""
    var hash: String = ""
    var limit: Int
    
    init(limit: Int) {
        self.limit = limit
        addCommonParams()
    }
}
