//
//  KNetworkError.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation

enum KNetworkError: Error {
    
    case error(message: String)
    case parserError(message: String)
    case invalidRequest
    case invalidResponse
    case badRequest(message: String)
    case unAuthorized(message: String)
    case internarServerError(message: String)
    
    var description: String {
        switch self {
        case .error(let message), .parserError(let message), .badRequest(let message), .unAuthorized(let message), .internarServerError(let message):
            return message
        case .invalidResponse:
            return "Invalid Response Error"
        case .invalidRequest:
            return "Invalid Request Error"
        }
    }
    
}
