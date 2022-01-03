//
//  BaseDTO.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 30/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation

struct BaseDTO: BaseProtocolDTO {
    
    var ts: String = ""
    var apikey: String = ""
    var hash: String = ""
    
    init() {
        addCommonParams()
    }
    
}
