//
//  Service.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import KNetwork

final class Service {
    
    public static func executeRequest<T: Decodable>(endpoint: KEndpointProtocol, model: T.Type, session: URLSession) async -> (Result<T, KNetworkError>) {
        let response = await KNetwork.executeRequest(endpoint: endpoint, session: session)
        switch response {
        case .success(let result):
            return manageResponse(result: result, endpoint: endpoint.path)
        case .failure(let error):
            print("❌ - Service: \(error.description) - ERROR - KO")
            return .failure(error)
        }
    }
    
    private static func manageResponse<T: Decodable>(result: (data: Data, statusCode: Int), endpoint: String) -> Result<T, KNetworkError> {
        switch result.statusCode {
        case 200...299:
            guard let dataParsed: T = try? KParser.parserData(result.data) else {
                print("Service❓: \(endpoint) - STATUS CODE: \(result.statusCode) - ERROR PARSER OBJECT - OK")
                return .failure(KNetworkError.parserError(message: "Can not parser object"))
            }
            print("✅ - Service: \(endpoint) - STATUS CODE: \(result.statusCode) - OK")
            return .success(dataParsed)
        default:
            print("❌ - Service: \(endpoint) - STATUS CODE: - \(result.statusCode) - KO")
            guard let errorResponse: WSErrorResponse = try? KParser.parserData(result.data) else {
                return .failure(KNetworkError.error(message: "ERROR RESPONSE - STATUS CODE: \(result.statusCode)"))
            }
            return .failure(KNetworkError.error(message: errorResponse.description))
        }
    }
}
