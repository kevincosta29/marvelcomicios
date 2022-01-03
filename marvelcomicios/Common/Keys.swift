//
//  Keys.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 25/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit

// MARK: - APP KEYS

let URL_BASE_KNETWORK                   : String        = "gateway.marvel.com"
let PUBLIC_KEY                          : String        = "195fcdd04967198512b0e689c9d6e7db"
let PRIVATE_KEY                         : String        = "686742c793338e365beddef1800a59d020402ae1"

// MARK: - CONSTANTS
let FADE_IN								: Double		= 0.5
let PRIMARY_COLOR						: UIColor		= .blue
let DARK_COLOR							: UIColor		= .darkGray
let NAV_TITLE_COLOR                     : UIColor       = UIColor(named: "NAV_TITLE")!
let NAV_BAR_COLOR                       : UIColor       = UIColor(named: "NAV_BAR")!

// MARK: - WS
let WS_CHARACTERS                       : String        = "/v1/public/characters"
let WS_CHARACTER_COMICS                 : String        = "/v1/public/characters/%d/comics"
let WS_CHARACTER_SERIES                 : String        = "/v1/public/characters/%d/series"

// MARK: - WS GLOBAL PARAM
let PARAM_HASH                          : String        = "hash"
let PARAM_API_KEY                       : String        = "apikey"
let PARAM_TIME_STAMP                    : String        = "ts"
let PARAM_ID                            : String        = "id"
let PARAM_LIMIT                         : String        = "limit"
