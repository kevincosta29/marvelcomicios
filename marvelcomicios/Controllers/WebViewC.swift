//
//  WebViewC.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 31/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewC: BaseC {
	
	//-----------------------
	// MARK: OUTLETS
	// MARK: ============
	//-----------------------
	
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewError: UIView!
	@IBOutlet weak var viewLoading: UIView!
	@IBOutlet weak var viewContent: UIView!
	@IBOutlet weak var btnRetry: UIButton!
	
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	
    private var url: URL!
    private var strTitle: String!
	
	//-----------------------
	// MARK: CONSTANTS
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
    init(url: URL, strTitle: String) {
		super.init(nibName: "WebViewC", bundle: Bundle.main)
        self.url = url
        self.strTitle = strTitle
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//-------------------------------- DISSENY ------------------------------------//
		
        self.title = strTitle
		configBackButton()
        viewAnimation.addLottie()
		
		//-----------------------------------------------------------------------------//
		
		// Do any additional setup after loading the view.
        
        viewContent.alpha = 0.0
        viewLoading.alpha = 1.0
        viewError.alpha = 0.0
        
        webView.navigationDelegate = self
        loadUrl()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
    @IBAction func actionBtnRetry(_ sender: Any) {
        showView(type: .viewLoading)
        loadUrl()
    }
    
	//-----------------------
	// MARK: - METHODS
	//-----------------------
    
    private func loadUrl() {
        webView.load(URLRequest(url: url))
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
	
	//-----------------------
	// MARK: - DATAMANAGER
	//-----------------------

    
}

extension WebViewC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showView(type: .viewContent)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showView(type: .viewError, mssgError: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showView(type: .viewLoading)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showView(type: .viewError, mssgError: error.localizedDescription)
    }
    
}
