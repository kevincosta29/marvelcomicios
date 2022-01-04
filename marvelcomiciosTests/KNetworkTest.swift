//
//  marvelcomiciosTests.swift
//  KNetworkTest
//
//  Created by Kevin Costa on 3/1/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import XCTest
@testable import marvelcomicios

class KNetworkTest: XCTestCase {
    
    private var session: MockURLSession!

    override func setUpWithError() throws {
        session = MockURLSession()
    }

    override func tearDownWithError() throws {
    }

    func test_InvalidRequest_Error() throws {
        let expectation = XCTestExpectation(description: "test_InvalidRequest")
        let expectedError = KNetworkError.invalidRequest
        
        KNetwork.executeRequest(endpoint: MockCharacterEndPoint.invalidRequestTest, session: session) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let err):
                XCTAssertEqual(expectedError, err)
                XCTAssertEqual(expectedError.description, KNetworkError.invalidRequest.description)
                expectation.fulfill()
            }
        }
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_ManageResponse_Error() throws {
        let expectation = XCTestExpectation(description: "test_ManageResponse_Error")
        let errorExpected = KNetworkError.error(message: "The operation couldn’t be completed. (marvelcomicios.KNetworkError error 0.)")
        
        session.error = errorExpected
        session.dataMock = nil
        
        KNetwork.executeRequest(endpoint: MockCharacterEndPoint.validRequest, session: session) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, errorExpected)
                XCTAssertEqual(error.description, errorExpected.description)
                expectation.fulfill()
            }
        }

        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_ResponseData_Error() throws {
        let expectation = XCTestExpectation(description: "test_ResponseData_Error")
        let errorExpected = KNetworkError.error(message: "Invalid Response Error")
        
        session.error = nil
        session.dataMock = nil
        session.statusCode = 200
        
        KNetwork.executeRequest(endpoint: MockCharacterEndPoint.validRequest, session: session) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.description, errorExpected.description)
                expectation.fulfill()
            }
        }

        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_Request_Success() throws {
        let expectation = XCTestExpectation(description: "test_Request_Success")
        let mockResponse = WSCharactersResponse(code: 200, status: "",
                                                data: WSCharactersDataResponse(offset: 50, limit: 50, total: 50, count: 50, results: []))
        
        session.error = nil
        session.dataMock = try? JSONEncoder().encode(mockResponse)
        
        KNetwork.executeRequest(endpoint: MockCharacterEndPoint.validRequest, session: session, completion: { result in
            switch result {
            case .success(let response):
                let dataObject = try? KParser<WSCharactersResponse>.parserData(response.data)
                XCTAssertEqual(dataObject?.code, mockResponse.code)
                XCTAssertEqual(dataObject?.status, mockResponse.status)
                XCTAssertEqual(dataObject?.data?.offset, mockResponse.data?.offset)
                XCTAssertEqual(dataObject?.data?.limit, mockResponse.data?.limit)
                XCTAssertEqual(dataObject?.data?.total, mockResponse.data?.total)
                XCTAssertEqual(dataObject?.data?.count, mockResponse.data?.count)
                XCTAssertEqual(dataObject?.data?.results.count, mockResponse.data?.results.count)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        })
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
        
    }

}
