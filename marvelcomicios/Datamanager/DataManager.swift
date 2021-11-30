//
//  DataManager.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 25/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import Alamofire

class DataManager {
	
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	
	private var manager         : Session
	private var params          : [String: Any]     = [:]
	
	public static var shared: DataManager = {
		return DataManager.init()
	}()
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	public init() {
		manager = {
			let configuration = URLSessionConfiguration.default
			configuration.urlCache = nil
			return Alamofire.Session(configuration: configuration)
		}()
	}
	
	func getDataAPI(strAction: String, method: HTTPMethod = .post, parameters: [String: Any]? = nil,
                    completionHandler: @escaping (_ result: AFResult<Any>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
		
        var params = parameters
		var strUrl = "\(URL_BASE)\(strAction)"
        if strAction.contains("%d"), let id = parameters?[PARAM_ID] as? Int {
           strUrl = String(format: strUrl, id)
            params?.removeValue(forKey: PARAM_ID)
        }

        manager.request(strUrl, method: method, parameters: params, encoding: method == .post ? JSONEncoding.default : URLEncoding.default, headers: nil).validate().responseJSON { (response) in
            self.manageResponse(response, strAction: strAction, parameters: parameters, completionHandler: completionHandler)
        }
	}
	
	private func manageResponse(_ response: AFDataResponse<Any>, strAction: String, parameters: [String: Any]? = nil, completionHandler: @escaping (_ result: AFResult<Any>, _ error: NSError?, _ strMsg: String?, _ array: [Any]?) -> Void) {
		var nsError: NSError
		
		if let codeError = response.response?.statusCode, codeError == 401 {
            nsError = NSError.init(domain: "error.sessionExpired".localized(), code: ERROR_CODE_SESSION_EXPIRED, userInfo: nil)
            completionHandler(response.result, nsError, nil, nil)
            return
		}
		
		switch response.result {
        case .success:
            let dictResult = self.process(data: response.data, paramsSent: parameters, strAction: strAction)
            
            if let token = dictResult[RESP_TOKEN] {
                if token is String, token as! String != "" {
                    UserDefaults.standard.set(token, forKey: RESP_TOKEN)
                } else {
                    nsError = NSError.init(domain: "error.sessionExpired".localized(), code: ERROR_CODE_SESSION_EXPIRED, userInfo: nil)
                    completionHandler(response.result, nsError, nil, nil)
                    return
                }
            }
            
            if let strResult = dictResult[RESP_WS_RESULT] as? String {
                let strMsg = dictResult[RESP_WS_STR_MSG] as? String
                let arrayResult = dictResult[RESP_ARRAY_RESULT] as? [Any]
                if strResult == STR_OK {
                    completionHandler(response.result, nil, strMsg, arrayResult)
                } else {
                    nsError = NSError.init(domain: strMsg == nil || strMsg == "" ? "defaultErrorMsg".localized() : strMsg!, code: ERROR_CODE_GENERIC, userInfo: nil)
                    completionHandler(response.result, nsError, strMsg, arrayResult)
                }
            }
        case .failure(let error):
            nsError = NSError.init(domain: error.localizedDescription, code: ERROR_CODE_GENERIC, userInfo: nil)
            completionHandler(response.result, nsError, nil, nil)
        }
	}
	
}
