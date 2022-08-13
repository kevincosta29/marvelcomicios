//
//  CharacterListViewModelTest.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 4/1/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import XCTest
import KNetwork
@testable import marvelcomicios

class CharacterListViewModelTest: XCTestCase {
    
    private var dataSource: MockedCharacterListDataSource!

    override func setUpWithError() throws {
        dataSource = MockedCharacterListDataSource()
    }
    
    func test_CharacterList_Success() throws {
        let expectation = XCTestExpectation(description: "test_CharacterList_Success")
        let mockUrlResponse = try XCTUnwrap(Bundle(for: CharacterListViewModelTest.self).url(forResource: "characterListMock", withExtension: "json"))
        let mockDataResponse = try Data(contentsOf: mockUrlResponse)
        let arrayObjects = try KParser<[Character]>.parserData(mockDataResponse)
        
        dataSource.result = .success(arrayObjects)
        
        let viewModel = CharacterListViewModel(dataSource: dataSource)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayCharacters.count, arrayObjects.count)
            expectation.fulfill()
        }
        
        viewModel.retrieveCharacterList(showLoading: false)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_CharacterListEmpty_Success() throws {
        let expectation = XCTestExpectation(description: "test_CharacterListEmpty_Success")
        dataSource.result = .failure(KNetworkError.error(message: "test_CharacterListEmpty_Success"))

        let viewModel = CharacterListViewModel(dataSource: dataSource)
        
        viewModel.showView = { type, msg in
            XCTAssert(viewModel.arrayCharacters.isEmpty)
            XCTAssertEqual(type, .viewError)
            XCTAssertNotNil(msg)
            XCTAssert(!msg!.isEmpty)
            expectation.fulfill()
        }

        viewModel.retrieveCharacterList(showLoading: false)

        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_CharacterListNilData_Success() throws {
        let expectation = XCTestExpectation(description: "test_CharacterListNilData_Success")
        dataSource.result = .failure(KNetworkError.error(message: "test_CharacterListNilData_Success"))

        let viewModel = CharacterListViewModel(dataSource: dataSource)

        viewModel.showView = { type, msg in
            XCTAssertEqual(viewModel.arrayCharacters.count, 0)
            XCTAssertEqual(type, .viewError)
            XCTAssertNotNil(msg)
            XCTAssert(!msg!.isEmpty)
            expectation.fulfill()
        }

        viewModel.retrieveCharacterList(showLoading: false)

        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_CharacterList_Failure() throws {
        let expectation = XCTestExpectation(description: "test_CharacterList_Failure")
        dataSource.result = .failure(KNetworkError.error(message: "test_CharacterList_Failure"))
       
        let viewModel = CharacterListViewModel(dataSource: dataSource)
        
        viewModel.showView = { type, msg in
            XCTAssert(viewModel.arrayCharacters.isEmpty)
            XCTAssertEqual(type, .viewError)
            XCTAssertNotNil(msg)
            XCTAssert(!msg!.isEmpty)
            expectation.fulfill()
        }
        
        viewModel.retrieveCharacterList(showLoading: false)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }

}
