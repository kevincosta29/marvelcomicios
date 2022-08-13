//
//  ServiceTest.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 3/1/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import XCTest
import KNetwork
@testable import marvelcomicios

class ServiceTest: XCTestCase {
    
    private var session: MockURLSession!

    override func setUpWithError() throws {
        session = MockURLSession()
    }

    override func tearDownWithError() throws {
    }

    func test_Request_Success() async throws {
        let mockResponse = WSCharactersResponse(code: 200, status: "",
                                                data: WSCharactersDataResponse(offset: 50, limit: 50, total: 50, count: 50, results: []))
        session.statusCode = 201
        session.dataMock = try? JSONEncoder().encode(mockResponse)
        
        let response = await Service.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session)
                
        switch response {
        case .success(let response):
            XCTAssertEqual(response.code, mockResponse.code)
            XCTAssertEqual(response.status, mockResponse.status)
            XCTAssertEqual(response.data?.offset, mockResponse.data?.offset)
            XCTAssertEqual(response.data?.limit, mockResponse.data?.limit)
            XCTAssertEqual(response.data?.total, mockResponse.data?.total)
            XCTAssertEqual(response.data?.count, mockResponse.data?.count)
            XCTAssertEqual(response.data?.results.count, mockResponse.data?.results.count)
        case .failure(_):
            XCTFail()
        }
    }
    
    func test_Request_Error() async throws {
        let errorExpected = KNetworkError.error(message: "test_Request_Error")
        session.error = errorExpected
        
        let response = await Service.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session)
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, errorExpected.localizedDescription)
        }
        
    }
    
    func test_RequestNotValidStatusCode() async throws {
        let mockResponse = WSErrorResponse(code: "", message: "test_Request_Error")
        
        session.statusCode = 401
        session.dataMock = try? JSONEncoder().encode(mockResponse)
        
        let errorExpected = KNetworkError.error(message: mockResponse.description)
        let response = await Service.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session)
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, errorExpected)
            XCTAssertEqual(error.description, mockResponse.description)
        }
    }
    
    func test_RequestNotValidStatus_InvalidParserData() async throws {
        let mockResponse = WSErrorResponse(code: "", message: "test_Request_Error")
        
        session.statusCode = 401
        session.dataMock = try? JSONEncoder().encode(mockResponse)
        
        let errorExpected = KNetworkError.error(message: mockResponse.description)
        let response = await Service.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session)
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, errorExpected)
        }
    }
    
    func test_RequestNotValidParserError() async throws {
        session.statusCode = 401
        session.dataMock = Data()
        
        let errorExpected = KNetworkError.error(message: "ERROR RESPONSE - STATUS CODE: \(session.statusCode)")
        let response = await Service.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session)
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, errorExpected)
        }
    }
    
    func test_InvalidDataParser_Success() async throws {
        let mockResponse = WSErrorResponse(code: "", message: "test_Request_Error")
        
        session.dataMock = try? JSONEncoder().encode(mockResponse)
        
        let errorExpected = KNetworkError.parserError(message: "Can not parser object")
        let response = await Service.executeRequest(endpoint: MockCharacterEndPoint.validRequest, model: WSCharactersResponse.self, session: session)
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, errorExpected)
        }
    }

}
