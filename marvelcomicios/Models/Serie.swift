//
//  Serie.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 30/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

struct Serie: Codable {
    
    var title       : String?
    var thumbnail   : Thumbnail?
	
	private enum CodingKeys: String, CodingKey {
		case title
        case thumbnail
	}
	
}
