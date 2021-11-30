//
//  DataManager+Characters.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 29/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation

extension DataManager {
	
	func processWS_GetCharacters(data: Data?, paramsSent: [String: Any]? = nil) -> [String: Any] {
		guard let data = data else { return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"] }
		
		do {
			let decoder = JSONDecoder()
            let wsResponse = try decoder.decode(WSCharactersResponse.self, from: data)
			
			return [RESP_WS_RESULT: wsResponse.status == STR_OK ? STR_OK : STR_KO,
                    RESP_ARRAY_RESULT: [wsResponse.data?.results ?? []]]
			
		} catch let err {
			print("Error - Name of the function: processWS_GetCharacters ==> ", err)
		}
		
		return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"]
	}
    
    func processWS_GetCharactersComics(data: Data?, paramsSent: [String: Any]? = nil) -> [String: Any] {
        guard let data = data else { return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"] }
        
        do {
            let decoder = JSONDecoder()
            let wsResponse = try decoder.decode(WSComicsResponse.self, from: data)
            
            return [RESP_WS_RESULT: wsResponse.status == STR_OK ? STR_OK : STR_KO,
                    RESP_ARRAY_RESULT: [wsResponse.data?.results ?? []]]
            
        } catch let err {
            print("Error - Name of the function: processWS_GetCharactersStories ==> ", err)
        }
        
        return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"]
    }
    
    func processWS_GetCharactersSeries(data: Data?, paramsSent: [String: Any]? = nil) -> [String: Any] {
        guard let data = data else { return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"] }
        
        do {
            let decoder = JSONDecoder()
            let wsResponse = try decoder.decode(WSSeriesResponse.self, from: data)
            
            return [RESP_WS_RESULT: wsResponse.status == STR_OK ? STR_OK : STR_KO,
                    RESP_ARRAY_RESULT: [wsResponse.data?.results ?? []]]
            
        } catch let err {
            print("Error - Name of the function: processWS_GetCharactersSeries ==> ", err)
        }
        
        return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "invalidData"]
    }
	
}
