//
//  CharacterDetailFlowManager.swift
//  marvelcomicios
//
//  Created by Kevin Costa on 12/7/22.
//  Copyright © 2022 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit

class CharacterDetailFlowManager: NSObject, CharacterDetailFlowManagerProtocol {
    
    //-----------------------
    // MARK: VARIABLES
    // MARK: ============
    //-----------------------
    
    private let character: Character
    private let navigationController: UINavigationController
    
    //-----------------------
    // MARK: - INIT
    //-----------------------
    
    init(navController: UINavigationController, character: Character) {
        self.navigationController = navController
        self.character = character
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func getSceneViewController() -> UINavigationController {
        return navigationController
    }
    
    func start() {
        let viewModel = CharacterDetailViewModel(dataSource: CharacterDetailDataSource())
        let vc = CharacterDetailC(character: character)
        
        vc.viewModel = viewModel
        vc.flowManager = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToWebView(url: URL, title: String) {
        let vc = WebViewC(url: url, strTitle: title)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openModal(arrayLinks: [Link]) {
        let vc = ModalListC(arrayLinks: character.urls ?? [], flowManager: self)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        navigationController.present(vc, animated: true)
    }
    
}

extension CharacterDetailFlowManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
