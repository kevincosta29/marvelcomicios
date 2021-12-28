// 
//  ModalListC.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 30/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit

class ModalListC: BaseC {
	
	//-----------------------
	// MARK: OUTLETS
	// MARK: ============
	//-----------------------
	
    @IBOutlet weak var viewDismiss: UIView!
    @IBOutlet weak var viewContent: UIView!
	@IBOutlet weak var tableView: UITableView!
    
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	
    private var pointOrigin: CGPoint?
    private var hasSetPointOrigin = false
    private var arrayLinks: [Link] = []
    private var controller: UIViewController!
    
	//-----------------------
	// MARK: CONSTANTS
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
    init(arrayLinks: [Link], cnt: UIViewController) {
		super.init(nibName: "ModalListC", bundle: Bundle.main)
        self.arrayLinks = arrayLinks
        self.controller = cnt
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-------------------------------- DISSENY ------------------------------------//
		
		// Amagar les cells buides
		tableView.tableFooterView = UIView(frame: .zero)
        viewContent.layer.cornerRadius = 20.0
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		
		//-----------------------------------------------------------------------------//
		
		// Do any additional setup after loading the view.
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        viewContent.addGestureRecognizer(panGesture)
        viewDismiss.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewContent)))
	}
    
    override func viewDidAppear(_ animated: Bool) { } 
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.viewContent.frame.origin
        }
    }
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
    
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
    
    @objc private func dismissViewContent() {
        self.dismiss(animated: true)
    }
    
    @objc private func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: viewContent)
        
        switch sender.state {
        case .changed:
            if translation.y >= 0 {
                viewContent.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
            }
        case .ended:
            let dragVelocity = sender.velocity(in: viewContent)
            if dragVelocity.y >= 1300 || translation.y > 150 {
                self.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.viewContent.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        default:
            break
        }
    }
}

	//----------------------------
	// MARK: - UITableViewDelegate
	//----------------------------

extension ModalListC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLinks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let object = arrayLinks[indexPath.row]
		let cell = UITableViewCell()

        cell.accessoryType = .disclosureIndicator
		
        cell.textLabel?.text = object.type?.capitalizingFirstLetter()
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = arrayLinks[indexPath.row]
        if let url = URL(string: object.url ?? "") {
            dismiss(animated: true)
            let vc = WebViewC(url: url, strTitle: object.type?.capitalizingFirstLetter() ?? "")
            self.controller.navigationController?.pushViewController(vc, animated: true)
        }
	}
	
}
