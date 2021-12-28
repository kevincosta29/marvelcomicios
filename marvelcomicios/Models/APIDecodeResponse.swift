//
//  APIDecode.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 29/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import UIKit

struct WSBaseResponse: Codable {
    
    var result                  : String?
    var strMsg                  : String?
    
    private enum CodingKeys: String, CodingKey {
        case result
        case strMsg
    }
}

struct WSCharactersResponse: Codable {
    
    var code                : Int?
    var status              : String?
    var data                : WSCharactersDataResponse?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case status
        case data
    }
}

struct WSCharactersDataResponse: Codable {
    
    var offset              : Int?
    var limit               : Int?
    var total               : Int?
    var count               : Int?
    var results             : [Character]
    
    private enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
}

struct WSComicsResponse: Codable {
    
    var code                : Int?
    var status              : String?
    var data                : WSComicsDataResponse?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case status
        case data
    }
}

struct WSComicsDataResponse: Codable {
    
    var offset              : Int?
    var limit               : Int?
    var total               : Int?
    var count               : Int?
    var results             : [Comic]
    
    private enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
}

struct WSSeriesResponse: Codable {
    
    var code                : Int?
    var status              : String?
    var data                : WSSeriesDataResponse?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case status
        case data
    }
}

struct WSSeriesDataResponse: Codable {
    
    var offset              : Int?
    var limit               : Int?
    var total               : Int?
    var count               : Int?
    var results             : [Serie]
    
    private enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
}
