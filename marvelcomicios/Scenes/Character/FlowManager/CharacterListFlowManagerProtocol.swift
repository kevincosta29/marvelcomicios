//
//  CharacterListFlowManagerProtocol.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterListFlowManagerProtocol {
    func start()
    func getSceneViewController() -> UINavigationController
    func goToDetail(character: Character)
}
