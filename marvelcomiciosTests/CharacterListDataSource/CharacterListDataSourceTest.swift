//
//  CharacterListDataSourceTest.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 13/8/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import XCTest
import KNetwork
@testable import marvelcomicios


class CharacterListDataSourceTest: XCTestCase {
    
    private var dataCharacterResponse: Data!
    private var arrayCharacter: [Character]!
    private var session: MockURLSession!
    
    override func setUpWithError() throws {
        session = MockURLSession()
        
        let mockCharacterUrl = try XCTUnwrap(Bundle(for: CharacterDetailViewModelTest.self).url(forResource: "characterListMock", withExtension: "json"))
        dataCharacterResponse = try Data(contentsOf: mockCharacterUrl)
        arrayCharacter = try KParser.parserData(dataCharacterResponse)
    }
    
    func test_getListSuccess() async throws {
        let objResponse = WSCharactersResponse(code: nil, status: nil, data: WSCharactersDataResponse(offset: 0, limit: 0, total: 0, count: 0, results: arrayCharacter))
        session.dataMock = try KParser.parserObject(objResponse)
        
        let dataSource = CharacterListDataSource(session: session)
        let response = await dataSource.getCharacterList()
        
        switch response {
        case .success(let response):
            XCTAssert(!response.isEmpty)
            XCTAssertEqual(arrayCharacter.count, response.count)
        case .failure(_):
            XCTFail()
        }
    }
    
    func test_getListEmpty() async throws {
        let objResponse = WSCharactersResponse(code: nil, status: nil, data: WSCharactersDataResponse(offset: 0, limit: 0, total: 0, count: 0, results: []))
        session.dataMock = try KParser.parserObject(objResponse)
        
        let dataSource = CharacterListDataSource(session: session)
        let response = await dataSource.getCharacterList()
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssert(!error.description.isEmpty)
        }
    }
    
    func test_getListFailure() async throws {
        session.error = KNetworkError.error(message: "")
        
        let dataSource = CharacterListDataSource(session: session)
        let response = await dataSource.getCharacterList()
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssert(!error.description.isEmpty)
        }
    }

}
