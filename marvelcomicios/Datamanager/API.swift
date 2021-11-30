//
//  API.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 25/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import Alamofire
import CryptoKit

class API {
    
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
    
    internal var params: [String: Any] = [:]
    
    public static var shared: API = {
        return API.init()
    }()
    
    private var timeStamp: String {
        get { return String(Date().timeIntervalSince1970) }
    }
    
    //-----------------------
	// MARK: - METHODS
	//-----------------------
	
	public init() { }
    
    private func addCommonParams(){
        let currentTimeStamp = timeStamp
        params[PARAM_TIME_STAMP] = currentTimeStamp
        params[PARAM_API_KEY] = PUBLIC_KEY
        params[PARAM_HASH] = generateHash(data: "\(currentTimeStamp)\(PRIVATE_KEY)\(PUBLIC_KEY)")
    }
    
    private func generateHash(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
	//-----------------------
	// MARK: - API METHODS
	//-----------------------
    
    func ws_Get_Characters(completionHandler: @escaping (_ result: AFResult<Any>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
        params = [:]
        addCommonParams()
        
        //Parameters for this ws
        params[PARAM_LIMIT] = 50
        
        DataManager.shared.getDataAPI(strAction: WS_CHARACTERS, method: .get, parameters: params) { result, error, strMsg, array in
            completionHandler(result, error, strMsg, array)
        }
    }
    
    func ws_Get_Characters_Comics(characterId: Int, completionHandler: @escaping (_ result: AFResult<Any>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
        params = [:]
        addCommonParams()
        
        //Parameters for this ws
        
        params[PARAM_ID] = characterId
        
        DataManager.shared.getDataAPI(strAction: WS_CHARACTER_COMICS, method: .get, parameters: params) { result, error, strMsg, array in
            completionHandler(result, error, strMsg, array)
        }
    }
    
    func ws_Get_Characters_Series(characterId: Int, completionHandler: @escaping (_ result: AFResult<Any>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
        params = [:]
        addCommonParams()
        
        //Parameters for this ws
        
        params[PARAM_ID] = characterId
        
        DataManager.shared.getDataAPI(strAction: WS_CHARACTER_SERIES, method: .get, parameters: params) { result, error, strMsg, array in
            completionHandler(result, error, strMsg, array)
        }
    }
    
	
}

	//------------------------------
	// MARK: - DataManager Extension
	//------------------------------

extension DataManager {
    
    func process(data: Data?, paramsSent: [String: Any]? = nil, strAction: String) -> [String: Any] {
        
        switch strAction {
        case WS_CHARACTERS:
            return processWS_GetCharacters(data: data, paramsSent: paramsSent)
        case WS_CHARACTER_COMICS:
            return processWS_GetCharactersComics(data: data, paramsSent: paramsSent)
        case WS_CHARACTER_SERIES:
            return processWS_GetCharactersSeries(data: data, paramsSent: paramsSent)
        default:
            print("WS not implemented in APP")
            return [RESP_WS_RESULT: STR_KO, RESP_WS_STR_MSG: "WS not implemented in APP"]
        }
        
    }
    
}
