//
//  BaseC.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 29/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import UIKit
import Alamofire

enum ViewType {
    case unknown, viewContent, viewLoading, viewError
}

enum CharacterDetailSection {
    case header, comics, series
}

protocol BaseControllerProtocol {
    func bind()
}

class BaseC: UIViewController, UIGestureRecognizerDelegate, BaseControllerProtocol {
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    //Changing Status Bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return traitCollection.userInterfaceStyle == .dark ? .lightContent : .default
    }
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.isTranslucent = true

        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            // prominent systemThinMaterial
            appearance.backgroundEffect = UIBlurEffect(style: .regular)
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                                              NSAttributedString.Key.foregroundColor : NAV_TITLE_COLOR]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let bounds = self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -(statusBarHeight)).offsetBy(dx: 0, dy: -(statusBarHeight))
            // Create blur effect.
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
            visualEffectView.frame = bounds!
            // Set navigation bar up.
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.addSubview(visualEffectView)
            self.navigationController?.navigationBar.sendSubviewToBack(visualEffectView)
            setNavBarTitleColorDark()
        }

        navigationController?.hairLine(hide: true)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (navigationController?.viewControllers.count)! > 1 {
            navigationController?.interactivePopGestureRecognizer!.isEnabled = true;
            navigationController?.interactivePopGestureRecognizer!.delegate = self;
            
        } else {
            navigationController?.interactivePopGestureRecognizer!.isEnabled = false;
            navigationController?.interactivePopGestureRecognizer!.delegate = nil;
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        switch previousTraitCollection?.userInterfaceStyle {
        case .light:
            UIApplication.shared.setStatusBar(style: .lightContent)
        case .dark:
            UIApplication.shared.setStatusBar(style: .default)
        default:
            UIApplication.shared.setStatusBar(style: .default)
        }
        self.viewDidLoad()
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func bind() {
        // Do nothing here
    }
    
    func restrictRotation(_ restriction: RotationType) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.restrictRotation = restriction
    }
    
    func configBackButton() {
        let img = UIImage(named: "ic_back")?.withRenderingMode(.alwaysOriginal)
        let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(self.popController))
        navigationItem.leftBarButtonItem = btn
    }
    
    @objc func popController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavBarTitleColorDark() {
        if self.navigationController != nil  {
            self.navigationController!.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                NSAttributedString.Key.foregroundColor: NAV_TITLE_COLOR]
        }
    }
    
    func addSubviewBase(_ newSubview: UIView, toView container: UIView) {
        newSubview.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(newSubview)
        
        let views = ["newSubview": newSubview]
        
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[newSubview]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[newSubview]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    func showControllerEraseOut(vc: UIViewController) {
        let transition = CATransition()
        transition.duration = FADE_IN
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
    
}

