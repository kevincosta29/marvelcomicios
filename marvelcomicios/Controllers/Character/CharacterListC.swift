// 
//  CharacterListC.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 29/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CharacterListC: BaseC {
	
	//-----------------------
	// MARK: OUTLETS
	// MARK: ============
	//-----------------------
	
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var viewError: UIView!
	@IBOutlet weak var viewLoading: UIView!
	@IBOutlet weak var viewContent: UIView!
	@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRetry: UIButton!
    
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	
    private var arrayCharacters: [Character] = []
	
	//-----------------------
	// MARK: CONSTANTS
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init() {
		super.init(nibName: "CharacterListC", bundle: Bundle.main)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-------------------------------- DISSENY ------------------------------------//
		
        viewAnimation.addLottie()
        self.title = "character.title".localized()
		// Amagar les cells buides
		tableView.tableFooterView = UIView(frame: .zero)
		
		//-----------------------------------------------------------------------------//
		
		// Do any additional setup after loading the view.
        
        wsCharactersList()
        tableView.addCustomRefresh(action: #selector(wsCharactersList), target: self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
    @IBAction func actionBtnRetry(_ sender: Any) {
        showView(type: .viewLoading)
        wsCharactersList()
    }
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
    
    @objc private func wsCharactersList() {
        API.shared.ws_Get_Characters { result, error, strMsg, array in
            self.processWSResponse(strAction: WS_CHARACTERS, result: result, error: error, strMsg: strMsg, array: array)
        }
    }
	
	private func showView(type: viewType, mssgError: String? = "") {
        switch type {
        case .viewContent:
            UIView.animate(withDuration: FADE_IN, animations: {
                self.viewContent.alpha = 1.0
                self.viewLoading.alpha = 0.0
                self.viewError.alpha = 0.0
            })
        case .viewLoading:
            UIView.animate(withDuration: FADE_IN, animations: {
                self.viewContent.alpha = 0.0
                self.viewLoading.alpha = 1.0
                self.viewError.alpha = 0.0
            })
        case .viewError:
            btnRetry.titleLabel?.textAlignment = .center
            btnRetry.setTitle("\(mssgError ?? "defaultErrorMsg".localized())\n\("RETRY".localized())", for: .normal)
            UIView.animate(withDuration: FADE_IN, animations: {
                self.viewContent.alpha = 0.0
                self.viewLoading.alpha = 0.0
                self.viewError.alpha = 1.0
            })
        default:
            break
        }
    }
	
	//-----------------------
	// MARK: - DATAMANAGER
	//-----------------------
	
	override func processWSResponse(strAction: String, result: AFResult<Any>, error: NSError?, strMsg: String?, array: [Any]?) {
		super.processWSResponse(strAction: strAction, result: result, error: error, strMsg: strMsg, array: array)
        tableView.refreshControl?.endRefreshing()
		
		switch result {
		case .success:
			if error != nil {
				print("\(self) >>> processWSResponse\nWS - \(strAction) = OK | Result = KO")
				showView(type: .viewError, mssgError: error?.domain ?? "defaultErrorMsg".localized())
			} else {
				print("\(self) >>> processWSResponse\nWS - \(strAction) = OK | Result = OK")
				showView(type: .viewContent)
                if let arrayObj = array?.first as? [Character] {
                    self.arrayCharacters = arrayObj
                }
                tableView.reloadData()
			}
		case .failure:
			print("\(self) >>> processWSResponse\nWS - \(strAction) = KO | Result = ?")
			showView(type: .viewError, mssgError: error?.domain ?? "defaultErrorMsg".localized())
		}
	}
}

	//----------------------------
	// MARK: - UITableViewDelegate
	//----------------------------

extension CharacterListC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCharacters.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let object = arrayCharacters[indexPath.row]
		let identifier = "CharacterCell"
		
		var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CharacterCell
		
		if cell == nil {
			tableView.register(UINib.init(nibName: identifier, bundle: Bundle(for: CharacterCell.self)), forCellReuseIdentifier: identifier)
			cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CharacterCell
		}
		
		cell?.configCellWithCharacter(object, cnt: self)
		
		cell?.setNeedsUpdateConstraints()
		cell?.updateConstraintsIfNeeded()
		
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = arrayCharacters[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(CharacterDetailC(character: object), animated: true)
	}
	
}
