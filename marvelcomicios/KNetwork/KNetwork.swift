//
//  KNetwork.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation

class KNetwork {
    
    public static func executeRequest(endpoint: KEndpointProtocol, session: URLSession,
                                      completion: @escaping (Result<(data: Data, statusCode: Int), KNetworkError>) -> Void) {
        guard let request = createRequest(endpoint: endpoint) else {
            let kNetworkError = KNetworkError.invalidRequest
            completion(.failure(kNetworkError))
            return
        }
                
        session.dataTask(with: request) { data, response, error in
            manageResponse(data: data, response: response, error: error) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tuple):
                        completion(.success((data: tuple.data, statusCode: tuple.statusCode)))
                    case .failure(let knetworkError):
                        completion(.failure(knetworkError))
                    }
                }
            }
        }.resume()
    }
    
    private static func manageResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping(Result<(data: Data, statusCode: Int), KNetworkError>) -> Void) {
        if let err = error {
            let knetworkError = KNetworkError.error(message: err.localizedDescription)
            completion(.failure(knetworkError))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, let d = data else {
            let knetworkError = KNetworkError.invalidResponse
            completion(.failure(knetworkError))
            return
        }
        completion(.success((data: d, statusCode: httpResponse.statusCode)))
    }
    
    private static func createRequest(endpoint: KEndpointProtocol) -> URLRequest? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.urlBase
        components.path = endpoint.path
        components.port = endpoint.port
        components.queryItems = endpoint.encoding.urlEncodingItems
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = endpoint.method.rawValue
        if endpoint.method == .POST {
            urlRequest.httpBody = endpoint.parametersBody
        }
        
        endpoint.headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        switch endpoint.contentType {
        case .json:
            urlRequest.addValue(endpoint.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        case .multipart:
            urlRequest.setValue("\(urlRequest.httpBody?.count ?? 0)", forHTTPHeaderField: "Content-Length")
        }
        
        return urlRequest
    }
    
}
