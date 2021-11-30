//
//  Comic.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 30/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

struct Comic: Codable {
    
    var title       : String?
    var thumbnail   : Thumbnail?
    var description : String?
    var isbn        : String?
	
	private enum CodingKeys: String, CodingKey {
        case title
        case thumbnail
        case description
        case isbn
	}
	
}
