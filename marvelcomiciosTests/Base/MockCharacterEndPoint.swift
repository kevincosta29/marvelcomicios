//
//  MockCharacterEndPoint.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 3/1/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation
import KNetwork
@testable import marvelcomicios

enum MockCharacterEndPoint: KEndpointProtocol {
    
    case invalidRequestTest
    case validRequest
    
    var scheme: String {
        return "https"
    }
    
    var urlBase: String {
        return "api.text.dev"
    }
    
    var path: String {
        switch self {
        case .invalidRequestTest:
            return "test/test"
        case .validRequest:
            return "/test/test"
        }
    }
    
    var parametersBody: Data? {
        return nil
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
    
    var port: Int {
        return 444
    }
    
    var encoding: KEncoding {
        return .json
    }
}
