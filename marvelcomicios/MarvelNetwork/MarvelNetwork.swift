//
//  MarvelNetwork.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation

final class MarvelNetwork {
    
    public static func executeRequest<T: Decodable>(endpoint: KEndpointProtocol, model: T.Type, session: URLSession,
                                                    completion: @escaping(Result<T, KNetworkError>) -> Void) {
        KNetwork.executeRequest(endpoint: endpoint, session: session) { result in
            switch result {
            case .success(let response):
                self.manageResponseSuccess(action: endpoint.path, response: response, completion: completion)
            case .failure(let err):
                print("MCNetwork: \(err.description) - ERROR - KO")
                completion(.failure(err))
            }
        }
    }
    
    private static func manageResponseSuccess<T: Decodable>(action: String, response: (data: Data, statusCode: Int),
                                                            completion: @escaping(Result<T, KNetworkError>) -> Void) {
        switch response.statusCode {
        case 200...299:
            guard let dataParsed = try? KParser<T>.parserData(response.data) else {
                completion(.failure(KNetworkError.parserError(message: "Can not parser object")))
                print("MarvelNetwork: \(action) - STATUS CODE: \(response.statusCode) - ERROR PARSER OBJECT - OK")
                return
            }
            print("MarvelNetwork: \(action) - STATUS CODE: \(response.statusCode) - OK")
            completion(.success(dataParsed))
        default:
            print("MarvelNetwork: \(action) - STATUS CODE: - \(response.statusCode) - KO")
            guard let errorResponse = try? KParser<WSErrorResponse>.parserData(response.data) else {
                completion(.failure(KNetworkError.error(message: "ERROR RESPONSE - STATUS CODE: \(response.statusCode)")))
                return
            }
            completion(.failure(KNetworkError.error(message: errorResponse.description)))
        }
    }
    
}

struct KParser<T: Decodable> {
    public static func parserData(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
