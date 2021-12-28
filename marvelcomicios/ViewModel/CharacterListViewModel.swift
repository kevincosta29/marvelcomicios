//
//  ViewModelCharacterList.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 27/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class CharacterListViewModel {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    private var controller: BaseControllerProtocol!
    var refreshData = { () -> () in }
    var arrayCharacters: [Character] = [] {
        didSet { refreshData() }
    }
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    init(controller: BaseControllerProtocol) {
        self.controller = controller
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func wsGetCharacterList() {
        API.shared.ws_Get_Characters { result, error, strMsg, array in
            switch result {
            case .success:
                if error != nil {
                    print("\(self) >>> processWSResponse\nWS - \(WS_CHARACTERS) = OK | Result = KO")
                    self.controller.showView(type: .viewError, mssgError: error?.domain ?? "defaultErrorMsg".localized())
                } else {
                    print("\(self) >>> processWSResponse\nWS - \(WS_CHARACTERS) = OK | Result = OK")
                    if let arrayObj = array?.first as? [Character] {
                        self.arrayCharacters = arrayObj
                        self.controller.showView(type: .viewContent, mssgError: nil)
                    } else {
                        self.arrayCharacters = []
                        self.controller.showView(type: .viewError, mssgError: "No se han encontrado valores")
                    }
                }
            case .failure:
                print("\(self) >>> processWSResponse\nWS - \(WS_CHARACTERS) = KO | Result = KO")
                self.controller.showView(type: .viewError, mssgError: strMsg ?? "defaultErrorMsg".localized())
            }
        }
    }
    
}
