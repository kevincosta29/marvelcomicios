// 
//  CharacterDetailC.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 30/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CharacterDetailC: BaseC {
	
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
	
	private var character: Character!
    private var arraySections: [CharacterDetailSection] = [.header]
    private var arrayComics: [Comic] = []
    private var arraySeries: [Serie] = []
	
	//-----------------------
	// MARK: CONSTANTS
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
    init(character: Character) {
		super.init(nibName: "CharacterDetailC", bundle: Bundle.main)
        self.character = character
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-------------------------------- DISSENY ------------------------------------//
		
        self.title = character.name
        configBackButton()
        viewAnimation.addLottie()
        
		// Amagar les cells buides
		tableView.tableFooterView = UIView(frame: .zero)
		
		//-----------------------------------------------------------------------------//
		
		// Do any additional setup after loading the view.
        tableView.addCustomRefresh(action: #selector(retrieveData), target: self)
        retrieveData()
        
        if !(character.urls?.isEmpty ?? true) {
            let img = UIImage(named: "ic_info")?.withRenderingMode(.alwaysOriginal)
            let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(self.openModal))
            navigationItem.rightBarButtonItem = btn
        }
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
        retrieveData()
    }
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
    
    @objc private func openModal() {
        let vc = ModalListC(arrayLinks: character.urls ?? [], cnt: self)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
    
    @objc private func retrieveData() {
        wsGetSeries()
        wsGetComics()
    }
    
    private func wsGetComics() {
        API.shared.ws_Get_Characters_Comics(characterId: character.id ?? -1) { result, error, strMsg, array in
            self.processWSResponse(strAction: WS_CHARACTER_COMICS, result: result, error: error, strMsg: strMsg, array: array)
        }
    }
    
    private func wsGetSeries() {
        API.shared.ws_Get_Characters_Series(characterId: character.id ?? -1) { result, error, strMsg, array in
            self.processWSResponse(strAction: WS_CHARACTER_SERIES, result: result, error: error, strMsg: strMsg, array: array)
        }
    }
    
    private func createContent() {
        arraySections = [.header]
        
        if !arrayComics.isEmpty {
            arraySections.append(.comics)
        }
        
        if !arraySeries.isEmpty {
            arraySections.append(.series)
        }
        
        showView(type: .viewContent)
        tableView.reloadData()
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
                switch strAction {
                case WS_CHARACTER_COMICS:
                    if let arrayObj = array?.first as? [Comic] {
                        self.arrayComics = arrayObj
                    }
                case WS_CHARACTER_SERIES:
                    if let arrayObj = array?.first as? [Serie] {
                        self.arraySeries = arrayObj
                    }
                default:
                    break
                }
                
                createContent()
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

extension CharacterDetailC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySections.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let object = arraySections[indexPath.row]
        switch object {
        case .header:
            let identifier = "CharacterImgCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CharacterImgCell
            
            if cell == nil {
                tableView.register(UINib.init(nibName: identifier, bundle: Bundle(for: CharacterImgCell.self)), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CharacterImgCell
            }
            
            cell?.configCellWithCharacter(character, cnt: self)
            
            cell?.setNeedsUpdateConstraints()
            cell?.updateConstraintsIfNeeded()
            
            return cell!
        case .comics, .series:
            let identifier = "CharacterContentCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CharacterContentCell
            
            if cell == nil {
                tableView.register(UINib.init(nibName: identifier, bundle: Bundle(for: CharacterContentCell.self)), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CharacterContentCell
            }
            
            switch object {
            case .comics:
                cell?.configCellWithComics(arrayComics, cnt: self)
            case .series:
                cell?.configCellWithSeries(arraySeries, cnt: self)
            default:
                break
            }
            
            cell?.setNeedsUpdateConstraints()
            cell?.updateConstraintsIfNeeded()
            
            return cell!
        }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
}

extension CharacterDetailC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
