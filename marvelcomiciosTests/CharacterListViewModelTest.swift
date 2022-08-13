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
    
    private var session: MockURLSession!

    override func setUpWithError() throws {
        session = MockURLSession()
    }
    
    func test_CharacterList_Success() throws {
        let expectation = XCTestExpectation(description: "test_CharacterList_Success")
        let mockUrlResponse = try XCTUnwrap(Bundle(for: CharacterListViewModelTest.self).url(forResource: "characterListMock", withExtension: "json"))
        let mockDataResponse = try Data(contentsOf: mockUrlResponse)
        let mockObjectResponse = try KParser<WSCharactersResponse>.parserData(mockDataResponse)
        
        session.dataMock = mockDataResponse
        
        let viewModel = CharacterListViewModel(dataSource: CharacterListDataSource())
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayCharacters.count, mockObjectResponse.data?.results.count)
            expectation.fulfill()
        }
        
        viewModel.retrieveCharacterList(showLoading: false)
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_CharacterListEmpty_Success() throws {
        let expectation = XCTestExpectation(description: "test_CharacterListEmpty_Success")
        let mockUrlResponse = try XCTUnwrap(Bundle(for: CharacterListViewModelTest.self).url(forResource: "characterListEmptyMock", withExtension: "json"))
        let mockDataResponse = try Data(contentsOf: mockUrlResponse)
        let mockObjectResponse = try KParser<WSCharactersResponse>.parserData(mockDataResponse)

        session.dataMock = mockDataResponse

        let viewModel = CharacterListViewModel(dataSource: CharacterListDataSource(session: session))
        
        viewModel.showView = { type, msg in
            XCTAssertEqual(viewModel.arrayCharacters.count, mockObjectResponse.data?.results.count)
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
        session.dataMock = try JSONEncoder().encode(WSCharactersResponse())

        let viewModel = CharacterListViewModel(dataSource: CharacterListDataSource(session: session))

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
        let error = KNetworkError.error(message: "test_CharacterList_Failure")
        session.error = error
       
        let viewModel = CharacterListViewModel(dataSource: CharacterListDataSource(session: session))
        
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

}
