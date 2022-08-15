//
//  CharacterDetailViewModelTest.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 4/1/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import XCTest
import KNetwork
@testable import marvelcomicios

class CharacterDetailViewModelTest: XCTestCase {
    
    private var dataSource: MockedCharacterDetailDataSource!

    override func setUpWithError() throws {
        dataSource = MockedCharacterDetailDataSource()
    }

    override func tearDownWithError() throws { }
    
    func test_GetComics_Success() throws {
        let expectation = XCTestExpectation(description: "test_GetComics_Success")
        let mockUrlResponse = try XCTUnwrap(Bundle(for: CharacterDetailViewModelTest.self).url(forResource: "characterComicsMock", withExtension: "json"))
        let mockDataResponse = try Data(contentsOf: mockUrlResponse)
        let mockObjectResponse = try KParser<[Comic]>.parserData(mockDataResponse)
        
        dataSource.resultComics = .success(mockObjectResponse)
        let viewModel = CharacterDetailViewModel(dataSource: dataSource)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayComics.count, mockObjectResponse.count)
            XCTAssertEqual(viewModel.arraySections.count, 2)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            XCTAssertEqual(viewModel.arraySections.last, .comics)
            expectation.fulfill()
        }
        
        viewModel.retrieveComics(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetComicsNilData_Success() throws {
        let expectation = XCTestExpectation(description: "test_GetComicsNilData_Success")
        dataSource.resultComics = .success([])
        let viewModel = CharacterDetailViewModel(dataSource: dataSource)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayComics.count, 0)
            XCTAssertEqual(viewModel.arraySections.count, 1)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            expectation.fulfill()
        }
        
        viewModel.retrieveComics(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetComics_Failure() throws {
        let expectation = XCTestExpectation(description: "test_GetComics_Failure")
        dataSource.resultComics = .failure(KNetworkError.error(message: "test_GetComics_Failure"))
        let viewModel = CharacterDetailViewModel(dataSource: dataSource)
        
        viewModel.showView = { type, msg in
            XCTAssertEqual(type, .viewError)
            XCTAssertNotNil(msg)
            XCTAssert(!msg!.isEmpty)
            expectation.fulfill()
        }
        
        viewModel.retrieveComics(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetSeries_Success() throws {
        let expectation = XCTestExpectation(description: "test_GetSeries_Success")
        let mockUrlResponse = try XCTUnwrap(Bundle(for: CharacterDetailViewModelTest.self).url(forResource: "characterSeriesMock", withExtension: "json"))
        let mockDataResponse = try Data(contentsOf: mockUrlResponse)
        let mockObjectResponse = try KParser<[Serie]>.parserData(mockDataResponse)
        
        dataSource.resultSeries = .success(mockObjectResponse)
        let viewModel = CharacterDetailViewModel(dataSource: dataSource)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arraySeries.count, mockObjectResponse.count)
            XCTAssertEqual(viewModel.arraySections.count, 2)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            XCTAssertEqual(viewModel.arraySections.last, .series)
            expectation.fulfill()
        }
        
        viewModel.retrieveSeries(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetSeriesNilData_Success() throws {
        let expectation = XCTestExpectation(description: "test_GetSeriesNilData_Success")
        dataSource.resultSeries = .success([])
        let viewModel = CharacterDetailViewModel(dataSource: dataSource)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arraySeries.count, 0)
            XCTAssertEqual(viewModel.arraySections.count, 1)
            XCTAssertEqual(viewModel.arraySections.first, .header)
            expectation.fulfill()
        }
        
        viewModel.retrieveSeries(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_GetSeries_Failure() throws {
        let expectation = XCTestExpectation(description: "test_GetSeries_Failure")
        dataSource.resultSeries = .failure(KNetworkError.error(message: "test_GetSeries_Failure"))
        let viewModel = CharacterDetailViewModel(dataSource: dataSource)
        
        viewModel.showView = { type, msg in
            XCTAssertEqual(type, .viewError)
            XCTAssertNotNil(msg)
            XCTAssert(!msg!.isEmpty)
            expectation.fulfill()
        }
        
        viewModel.retrieveSeries(id: 50)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }

}
