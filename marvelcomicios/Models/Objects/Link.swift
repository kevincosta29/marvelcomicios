//
//  Link.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 30/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

struct Link: Codable {
    
    var type        : String?
    var url         : String?
	
	private enum CodingKeys: String, CodingKey {
		case type
        case url
	}
	
}
