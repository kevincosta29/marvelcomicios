//
//  CharacterListViewModelTest.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 4/1/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import XCTest
@testable import marvelcomicios

class CharacterListViewModelTest: XCTestCase {
    
    private var session: URLSessionMock!
    private var mockController: BaseControllerProtocol!

    override func setUpWithError() throws {
        mockController = MockViewController()
        session = URLSessionMock()
    }

    override func tearDownWithError() throws {
    }
    
    func test_CharacterList_Success() throws {
        let expectation = XCTestExpectation(description: "test_CharacterList_Success")
        let mockUrlResponse = try XCTUnwrap(Bundle(for: CharacterListViewModelTest.self).url(forResource: "characterListMock", withExtension: "json"))
        let mockDataResponse = try Data(contentsOf: mockUrlResponse)
        let mockObjectResponse = try KParser<WSCharactersResponse>.parserData(mockDataResponse)
        
        session.dataMock = mockDataResponse
        
        let viewModel = CharacterListViewModel(controller: mockController, urlSession: session)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayCharacters.count, mockObjectResponse.data?.results.count)
            expectation.fulfill()
        }
        
        viewModel.wsGetCharacterList()
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_CharacterListEmpty_Success() throws {
        let expectation = XCTestExpectation(description: "test_CharacterListEmpty_Success")
        let mockUrlResponse = try XCTUnwrap(Bundle(for: CharacterListViewModelTest.self).url(forResource: "characterListMockEmpty", withExtension: "json"))
        let mockDataResponse = try Data(contentsOf: mockUrlResponse)
        let mockObjectResponse = try KParser<WSCharactersResponse>.parserData(mockDataResponse)
        
        session.dataMock = mockDataResponse
        
        let viewModel = CharacterListViewModel(controller: mockController, urlSession: session)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayCharacters.count, mockObjectResponse.data?.results.count)
            expectation.fulfill()
        }
        
        viewModel.wsGetCharacterList()
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }
    
    func test_CharacterList_Failure() throws {
        let expectation = XCTestExpectation(description: "test_CharacterList_Failure")
        session.error = KNetworkError.error(message: "test_CharacterList_Failure")
       
        let viewModel = CharacterListViewModel(controller: mockController, urlSession: session)
        
        viewModel.refreshData = {
            XCTAssertEqual(viewModel.arrayCharacters.count, 0)
            expectation.fulfill()
        }
        
        viewModel.wsGetCharacterList()
        
        let waiter = XCTWaiter.wait(for: [expectation], timeout: 5)
        XCTAssertEqual(waiter, .completed)
    }

}

class MockViewController: BaseControllerProtocol {
    
    func showView(type: ViewType, mssgError: String?) { }
    
}
