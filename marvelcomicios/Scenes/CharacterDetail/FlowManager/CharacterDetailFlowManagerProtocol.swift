//
//  CharacterDetailFlowManagerProtocol.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit

protocol CharacterDetailFlowManagerProtocol {
    func start()
    func getSceneViewController() -> UINavigationController
    func goToWebView(url: URL, title: String)
    func openModal(arrayLinks: [Link])
}
