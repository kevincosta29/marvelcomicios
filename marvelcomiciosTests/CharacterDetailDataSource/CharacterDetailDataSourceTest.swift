//
//  CharacterDetailDataSourceTest.swift
//  marvelcomiciosTests
//
//  Created by Kevin Costa on 15/8/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import XCTest
import KNetwork
@testable import marvelcomicios

class CharacterDetailDataSourceTest: XCTestCase {

    private var seriesData: Data!
    private var arraySeries: [Serie]!
    private var comicsData: Data!
    private var arrayComics: [Comic]!
    private var session: MockURLSession!
    
    override func setUpWithError() throws {
        session = MockURLSession()
        
        let mockSeriesUrl = try XCTUnwrap(Bundle(for: CharacterDetailViewModelTest.self).url(forResource: "characterSeriesMock", withExtension: "json"))
        seriesData = try Data(contentsOf: mockSeriesUrl)
        arraySeries = try KParser<[Serie]>.parserData(seriesData)
        
        let mockComicsUrl = try XCTUnwrap(Bundle(for: CharacterDetailViewModelTest.self).url(forResource: "characterSeriesMock", withExtension: "json"))
        comicsData = try Data(contentsOf: mockComicsUrl)
        arrayComics = try KParser<[Comic]>.parserData(comicsData)
    }
    
    func test_getComicsSuccess() async throws {
        let objResponse = WSComicsResponse(code: nil, status: nil, data: WSComicsDataResponse(offset: nil, limit: nil, total: nil, count: nil, results: arrayComics))
        session.dataMock = try KParserObject.parserObject(objResponse)
        
        let dataSource = CharacterDetailDataSource(session: session)
        let response = await dataSource.getComics(id: 10)
        
        switch response {
        case .success(let array):
            XCTAssertEqual(array.count, arraySeries.count)
        case .failure(_):
            XCTFail()
        }
    }
    
    func test_getEmptyComics() async throws {
        let objResponse = WSComicsResponse(code: nil, status: nil, data: WSComicsDataResponse(offset: nil, limit: nil, total: nil, count: nil, results: nil))
        session.dataMock = try KParserObject.parserObject(objResponse)
        
        let dataSource = CharacterDetailDataSource(session: session)
        let response = await dataSource.getComics(id: 10)
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssert(!error.description.isEmpty)
        }
    }
    
    func test_getComicsFailure() async throws {
        session.error = KNetworkError.error(message: "")
        let dataSource = CharacterDetailDataSource(session: session)
        let response = await dataSource.getComics(id: 10)
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssert(!error.description.isEmpty)
        }
    }
    
    func test_getSeriesSuccess() async throws {
        let objResponse = WSSeriesResponse(code: nil, status: nil, data: WSSeriesDataResponse(offset: nil, limit: nil, total: nil, count: nil, results: arraySeries))
        session.dataMock = try KParserObject.parserObject(objResponse)
        
        let dataSource = CharacterDetailDataSource(session: session)
        let response = await dataSource.getSeries(id: 10)
        
        switch response {
        case .success(let array):
            XCTAssertEqual(array.count, arraySeries.count)
        case .failure(_):
            XCTFail()
        }
    }
    
    func test_getEmptySeries() async throws {
        let objResponse = WSSeriesResponse(code: nil, status: nil, data: WSSeriesDataResponse(offset: nil, limit: nil, total: nil, count: nil, results: nil))
        session.dataMock = try KParserObject.parserObject(objResponse)
        
        let dataSource = CharacterDetailDataSource(session: session)
        let response = await dataSource.getSeries(id: 10)
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssert(!error.description.isEmpty)
        }
    }
    
    func test_getSeriesFailure() async throws {
        session.error = KNetworkError.error(message: "")
        let dataSource = CharacterDetailDataSource(session: session)
        let response = await dataSource.getSeries(id: 10)
        
        switch response {
        case .success(_):
            XCTFail()
        case .failure(let error):
            XCTAssert(!error.description.isEmpty)
        }
    }

}
