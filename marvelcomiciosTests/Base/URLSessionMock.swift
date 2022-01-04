//
//  URLSessionMock.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 3/1/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation

public class URLSessionMock: URLSession {
    
    var dataMock: Data?
    var statusCode: Int = 200
    var error: Error?
    
    public override var configuration: URLSessionConfiguration {
        return .default
    }
    
    public override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: request.allHTTPHeaderFields!)
        completionHandler(dataMock, response, error)
        return URLSession.shared.dataTask(with: request.url!)
    }
    
}
