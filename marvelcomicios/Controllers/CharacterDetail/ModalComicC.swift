//
//  ModalComicC.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 31/8/21.
//  Copyright © 2021 Marvel Comic. All rights reserved.
//

import Foundation
import UIKit

class ModalComicC: BaseC {
	
	//-----------------------
	// MARK: OUTLETS
	// MARK: ============
	//-----------------------
	
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblIsbn: UILabel!
    @IBOutlet weak var viewDismiss: UIView!
    
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	
	private var comic: Comic!
    private var pointOrigin: CGPoint?
    private var hasSetPointOrigin = false
	
	//-----------------------
	// MARK: CONSTANTS
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
    init(comic: Comic) {
		super.init(nibName: "ModalComicC", bundle: Bundle.main)
        self.comic = comic
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-------------------------------- DISSENY ------------------------------------//
		
        viewContent.layer.cornerRadius = 20.0
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		
		//-----------------------------------------------------------------------------//
		
		// Do any additional setup after loading the view.
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        viewContent.addGestureRecognizer(panGesture)
        viewDismiss.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewContent)))
        
        createContent()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
    
    override func viewDidAppear(_ animated: Bool) { }
    
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
	
    private func createContent() {
        lblTitle.text = comic.title
        lblDesc.text = comic.description
        lblIsbn.text = comic.isbn
        if let url = comic.thumbnail?.urlImg {
            imgContent.af.setImage(withURL: url, imageTransition: .crossDissolve(FADE_IN))
        }
    }
    
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
