//
//  BaseProtocolDTO.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 30/12/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import CryptoKit

protocol BaseProtocolDTO: Codable {
    var ts: String { get set }
    var apikey: String { get set }
    var hash: String { get set }
}

extension BaseProtocolDTO {
    mutating func addCommonParams() {
        let timeStamp = String(Date().timeIntervalSince1970)
        let currentTimeStamp = timeStamp
        let strData = "\(currentTimeStamp)\(PRIVATE_KEY)\(PUBLIC_KEY)"
        let hash = Insecure.MD5.hash(data: strData.data(using: .utf8) ?? Data())
        let strHash = hash.map { String(format: "%02hhx", $0) }.joined()
        
        self.ts = timeStamp
        self.apikey = PUBLIC_KEY
        self.hash = strHash
    }
}
