//
//  AppConfig.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 25/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ERROR CODES

let ERROR_CODE_GENERIC                  : Int           = 2
let ERROR_CODE_SESSION_EXPIRED          : Int           = 3

// MARK: - APP KEYS

let URL_BASE                            : String        = "https://gateway.marvel.com:443/v1/public/"
let PUBLIC_KEY                          : String        = ""
let PRIVATE_KEY                         : String        = ""

// MARK: - CONSTANTS
let STR_OK                              : String        = "Ok"
let STR_KO                              : String        = "Ko"
let FADE_IN								: Double		= 0.5
let PRIMARY_COLOR						: UIColor		= .blue
let DARK_COLOR							: UIColor		= .darkGray
let NAV_TITLE_COLOR                     : UIColor       = UIColor(named: "NAV_TITLE")!
let NAV_BAR_COLOR                       : UIColor       = UIColor(named: "NAV_BAR")!

// MARK: - WS
let WS_CHARACTERS                       : String        = "characters"
let WS_CHARACTER_COMICS                 : String        = "characters/%d/comics"
let WS_CHARACTER_SERIES                 : String        = "characters/%d/series"

// MARK: - WS GLOBAL PARAM
let PARAM_HASH                          : String        = "hash"
let PARAM_API_KEY                       : String        = "apikey"
let PARAM_TIME_STAMP                    : String        = "ts"
let PARAM_ID                            : String        = "id"
let PARAM_LIMIT                         : String        = "limit"

// MARK: - WS GLOBAL RESP
let RESP_WS_RESULT                      : String        = "result"
let RESP_WS_STR_MSG                     : String        = "strMsg"
let RESP_ARRAY_RESULT                   : String        = "arrayResult"
let RESP_TOKEN                          : String        = "token"
