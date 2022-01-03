//
//  APIDecode.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 29/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import UIKit

// MARK: - List of characters
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

// MARK: - List of Comics from character

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
    var results             : [Comic]?
    
    private enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
}

// MARK: - List of Series from character

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
    var results             : [Serie]?
    
    private enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
}

// MARK: - Base error response

struct WSErrorResponse: Codable {
    var code                : String?
    var message             : String?
    var description         : String {
        return "Code: \(code ?? "") - Message: \(message ?? "")"
    }
    
    private enum CodingKeys: String, CodingKey {
        case code
        case message
    }
    
}
