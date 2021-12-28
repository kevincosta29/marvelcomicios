//
//  Thumbnail.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 30/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation

struct Thumbnail: Codable {
    
    var path            : String?
    var extensionImg    : String?
    var urlImg          : URL? {
        return URL(string: String(format: "%@.%@", path ?? "", extensionImg ?? ""))
    }
	
	private enum CodingKeys: String, CodingKey {
        case path
        case extensionImg = "extension"
	}
	
}
