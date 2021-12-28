//
//  CharacterDetailViewModel.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 28/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import Alamofire

class CharacterDetailViewModel {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    private var controller: BaseControllerProtocol!
    var refreshData = { () -> () in }
    var arrayComics: [Comic] = [] {
        didSet { refreshData() }
    }
    var arraySeries: [Serie] = [] {
        didSet { refreshData() }
    }
    var arraySections: [CharacterDetailSection] = []
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    init(controller: BaseControllerProtocol) {
        self.controller = controller
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func wsGetComics(id: Int) {
        API.shared.ws_Get_Characters_Comics(characterId: id) { result, error, strMsg, array in
            self.processWSResponse(strAction: WS_CHARACTER_COMICS, result: result, error: error, strMsg: strMsg, array: array)
        }
    }
    
    func wsGetSeries(id: Int) {
        API.shared.ws_Get_Characters_Series(characterId: id) { result, error, strMsg, array in
            self.processWSResponse(strAction: WS_CHARACTER_SERIES, result: result, error: error, strMsg: strMsg, array: array)
        }
    }
    
    private func createContent() {
        arraySections = [.header]
        
        if !arrayComics.isEmpty {
            arraySections.append(.comics)
        }
        
        if !arraySeries.isEmpty {
            arraySections.append(.series)
        }
        
        refreshData()
        controller.showView(type: .viewContent, mssgError: nil)
    }
    
    private func processWSResponse(strAction: String, result: AFResult<Any>, error: NSError?, strMsg: String?, array: [Any]?) {
        switch result {
        case .success:
            if error != nil {
                print("\(self) >>> processWSResponse\nWS - \(strAction) = OK | Result = KO")
                controller.showView(type: .viewError, mssgError: error?.domain ?? "defaultErrorMsg".localized())
            } else {
                print("\(self) >>> processWSResponse\nWS - \(strAction) = OK | Result = OK")
                switch strAction {
                case WS_CHARACTER_COMICS:
                    if let arrayObj = array?.first as? [Comic] {
                        self.arrayComics = arrayObj
                    }
                case WS_CHARACTER_SERIES:
                    if let arrayObj = array?.first as? [Serie] {
                        self.arraySeries = arrayObj
                    }
                default:
                    break
                }
                createContent()
            }
        case .failure:
            print("\(self) >>> processWSResponse\nWS - \(strAction) = KO | Result = ?")
            controller.showView(type: .viewError, mssgError: error?.domain ?? "defaultErrorMsg".localized())
        }
    }
    
}
