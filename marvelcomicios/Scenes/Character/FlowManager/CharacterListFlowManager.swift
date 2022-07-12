//
//  CharacterListFlowManager.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit

class CharacterListFlowManager: CharacterListFlowManagerProtocol {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    private let navigationController: UINavigationController
    
    //-----------------------
    // MARK: - INIT
    //-----------------------
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func getSceneViewController() -> UINavigationController {
        return navigationController
    }
    
    func start() {
        let viewModel = CharacterListViewModel(dataSource: CharacterListDataSource())
        let vc = CharacterListC()
        vc.viewModel = viewModel
        vc.flowManager = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToDetail(character: Character) {
        let flowManager = CharacterDetailFlowManager(navController: navigationController, character: character)
        flowManager.start()
    }
    
}
