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
    private var viewModel: CharacterDetailViewModel!
	
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
        self.viewModel = CharacterDetailViewModel(controller: self)
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
        bind(to: viewModel)
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
    
    private func bind(to viewModel: CharacterDetailViewModel) {
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
        viewModel.wsGetComics(id: character.id ?? -1)
        viewModel.wsGetSeries(id: character.id ?? -1)
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

extension CharacterDetailC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arraySections.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = viewModel.arraySections[indexPath.row]
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
                cell?.configCellWithComics(viewModel.arrayComics, cnt: self)
            case .series:
                cell?.configCellWithSeries(viewModel.arraySeries, cnt: self)
            default:
                break
            }
            
            cell?.setNeedsUpdateConstraints()
            cell?.updateConstraintsIfNeeded()
            
            return cell!
        }
	}
	
}

extension CharacterDetailC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
