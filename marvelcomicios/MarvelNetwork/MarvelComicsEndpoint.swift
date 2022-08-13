//
//  MarvelComicsEndpoint.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import CryptoKit
import KNetwork

enum MarvelComicsEndpoint: KEndpointProtocol {
    
    case wsGetCharacters(params: CharacterListDTO)
    case wsGetCharacterComics(id:  Int)
    case wsGetCharacterSeries(id: Int)
    
    var scheme: String {
        return "https"
    }
    
    var port: Int {
        return 443
    }
    
    var urlBase: String {
        return URL_BASE_KNETWORK
    }
    
    var path: String {
        switch self {
        case .wsGetCharacters:
            return WS_CHARACTERS
        case .wsGetCharacterComics(let id):
            return String(format: WS_CHARACTER_COMICS, id)
        case .wsGetCharacterSeries(let id):
            return String(format: WS_CHARACTER_SERIES, id)
        }
    }
    
    var parametersBody: Data? {
        switch self {
        case .wsGetCharacters(let reqParam):
            return try? JSONEncoder().encode(reqParam)
        case .wsGetCharacterSeries, .wsGetCharacterComics:
            let baseReq = BaseDTO()
            return try? JSONEncoder().encode(baseReq)
        }
    }
    
    var encoding: KEncoding {
        return .urlEncoding(params: self.parametersBody)
    }
    
    var method: KURLMethod {
        return .GET
    }
    
    var contentType: KContentType {
        return .json
    }
    
    var headers: [String : String] {
        return [:]
    }
    
}
