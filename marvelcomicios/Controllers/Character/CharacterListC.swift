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
	//-----------------------
	
    private var viewModel: CharacterListViewModel!
	
	//-----------------------
	// MARK: CONSTANTS
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init() {
		super.init(nibName: "CharacterListC", bundle: Bundle.main)
        self.viewModel = CharacterListViewModel(controller: self)
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
        bind(to: viewModel)
        
        tableView.addCustomRefresh(action: #selector(pullToRefreshData), target: self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        viewModel.wsGetCharacterList()
	}
    
    private func bind(to viewModel: CharacterListViewModel) {
        viewModel.refreshData = { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
    @IBAction func actionBtnRetry(_ sender: Any) {
        showView(type: .viewLoading)
        viewModel.wsGetCharacterList()
    }
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
    
    @objc private func pullToRefreshData() {
        viewModel.wsGetCharacterList()
    }
    
    override func showView(type: ViewType, mssgError: String? = "") {
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
    
}

	//----------------------------
	// MARK: - UITableViewDelegate
	//----------------------------

extension CharacterListC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayCharacters.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = viewModel.arrayCharacters[indexPath.row]
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
        let object = viewModel.arrayCharacters[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(CharacterDetailC(character: object), animated: true)
	}
	
}
