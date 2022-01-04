//
//  CharacterDetailViewModelTest.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 4/1/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import XCTest
@testable import marvelcomicios

class CharacterDetailViewModelTest: XCTestCase {
    
    private var session: MockURLSession!
    private var mockController: BaseControllerProtocol!

    override func setUpWithError() throws {
        session = MockURLSession()
        mockController = MockViewController()
    }

    override func tearDownWithError() throws { }
    
    func test_GetComics_Success() throws {
        let expectation = XCTestExpectation(description: "test_GetComics_Success")
        let mockUrlResponse = try XCTUnwrap(Bundle(for: CharacterDetailViewModelTest.self).url(forResource: "characterComicsMock", withExtension: "json"))
        let mockDataResponse = try Data(contentsOf: mockUrlResponse)
        let mockObjectResponse = try KParser<WSComicsResponse>.parserData(mockDataResponse)
        
        session.dataMock = mockDataResponse
        let viewModel = CharacterDetailViewModel(controller: mockController, session: session)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayComics.count, mockObjectResponse.data?.results?.count)
            XCTAssertEqual(viewModel.arraySections.count, 2)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            XCTAssertEqual(viewModel.arraySections.last, .comics)
            expectation.fulfill()
        }
        
        viewModel.wsGetComics(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetComicsNilData_Success() throws {
        let expectation = XCTestExpectation(description: "test_GetComicsNilData_Success")
        session.dataMock = try JSONEncoder().encode(WSComicsResponse())
        let viewModel = CharacterDetailViewModel(controller: mockController, session: session)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayComics.count, 0)
            XCTAssertEqual(viewModel.arraySections.count, 1)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            expectation.fulfill()
        }
        
        viewModel.wsGetComics(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetComics_Failure() throws {
        let expectation = XCTestExpectation(description: "test_GetComics_Failure")
        session.dataMock = Data()
        session.error = KNetworkError.error(message: "test_GetComics_Failure")
        let viewModel = CharacterDetailViewModel(controller: mockController, session: session)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayComics.count, 0)
            XCTAssertEqual(viewModel.arraySections.count, 1)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            expectation.fulfill()
        }
        
        viewModel.wsGetComics(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetSeries_Success() throws {
        let expectation = XCTestExpectation(description: "test_GetSeries_Success")
        let mockUrlResponse = try XCTUnwrap(Bundle(for: CharacterDetailViewModelTest.self).url(forResource: "characterSeriesMock", withExtension: "json"))
        let mockDataResponse = try Data(contentsOf: mockUrlResponse)
        let mockObjectResponse = try KParser<WSSeriesResponse>.parserData(mockDataResponse)
        
        session.dataMock = mockDataResponse
        let viewModel = CharacterDetailViewModel(controller: mockController, session: session)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arraySeries.count, mockObjectResponse.data?.results?.count)
            XCTAssertEqual(viewModel.arraySections.count, 2)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            XCTAssertEqual(viewModel.arraySections.last, .series)
            expectation.fulfill()
        }
        
        viewModel.wsGetSeries(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetSeriesNilData_Success() throws {
        let expectation = XCTestExpectation(description: "test_GetSeriesNilData_Success")
        session.dataMock = try JSONEncoder().encode(WSSeriesResponse())
        let viewModel = CharacterDetailViewModel(controller: mockController, session: session)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arraySeries.count, 0)
            XCTAssertEqual(viewModel.arraySections.count, 1)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            expectation.fulfill()
        }
        
        viewModel.wsGetSeries(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetSeries_Failure() throws {
        let expectation = XCTestExpectation(description: "test_GetSeries_Failure")
        session.error = KNetworkError.error(message: "test_GetSeries_Failure")
        let viewModel = CharacterDetailViewModel(controller: mockController, session: session)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arraySeries.count, 0)
            XCTAssertEqual(viewModel.arraySections.count, 1)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            expectation.fulfill()
        }
        
        viewModel.wsGetSeries(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }

}
