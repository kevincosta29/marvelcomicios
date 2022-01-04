//
//  MarvelNetwork_Test.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 3/1/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import XCTest
@testable import marvelcomicios

class MarvelNetwork_Test: XCTestCase {
    
    private var session: URLSessionMock!

    override func setUpWithError() throws {
        session = URLSessionMock()
    }

    override func tearDownWithError() throws {
    }

    func test_Request_Success() throws {
        let expectation = XCTestExpectation(description: "test_Request_Success")
        let mockResponse = WSCharactersResponse(code: 200, status: "",
                                                data: WSCharactersDataResponse(offset: 50, limit: 50, total: 50, count: 50, results: []))
        session.statusCode = 201
        session.dataMock = try? JSONEncoder().encode(mockResponse)
        
        MarvelNetwork.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.code, mockResponse.code)
                XCTAssertEqual(response.status, mockResponse.status)
                XCTAssertEqual(response.data?.offset, mockResponse.data?.offset)
                XCTAssertEqual(response.data?.limit, mockResponse.data?.limit)
                XCTAssertEqual(response.data?.total, mockResponse.data?.total)
                XCTAssertEqual(response.data?.count, mockResponse.data?.count)
                XCTAssertEqual(response.data?.results.count, mockResponse.data?.results.count)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_Request_Error() throws {
        let expectation = XCTestExpectation(description: "test_Request_Error")
        let errorExpected = KNetworkError.error(message: "test_Request_Error")
        
        session.error = errorExpected
        
        MarvelNetwork.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, errorExpected.localizedDescription)
                expectation.fulfill()
            }
        }
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_RequestNotValidStatusCode() throws {
        let expectation = XCTestExpectation(description: "test_Request_Error")
        let mockResponse = WSErrorResponse(code: "", message: "")
        session.statusCode = 401
        session.dataMock = try? JSONEncoder().encode(mockResponse)
        
        let errorExpected = KNetworkError.error(message: mockResponse.description)
        
        MarvelNetwork.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, errorExpected)
                expectation.fulfill()
            }
        }
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_RequestNotValidStatus_InvalidParserData() throws {
        let expectation = XCTestExpectation(description: "test_Request_Error")
        let mockResponse = WSCharactersResponse(code: 200, status: "",
                                                data: WSCharactersDataResponse(offset: 50, limit: 50, total: 50, count: 50, results: []))
        session.statusCode = 401
        session.dataMock = try? JSONEncoder().encode(mockResponse)
        
        let errorExpected = KNetworkError.error(message: "ERROR RESPONSE - STATUS CODE: \(session.statusCode)")
        
        MarvelNetwork.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, errorExpected)
                expectation.fulfill()
            }
        }
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_InvalidDataParser_Success() throws {
        let expectation = XCTestExpectation(description: "test_Request_Error")
        let mockResponse = WSErrorResponse(code: "", message: "")
        
        session.dataMock = try? JSONEncoder().encode(mockResponse)
        
        let errorExpected = KNetworkError.parserError(message: "Can not parser object")
        
        MarvelNetwork.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, errorExpected)
                expectation.fulfill()
            }
        }
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }

}
