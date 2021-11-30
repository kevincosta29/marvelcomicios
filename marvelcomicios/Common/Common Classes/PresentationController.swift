//
//  PresentationController.swift
//  Marvel Comic
//
//  Created by Kevin Costa 30/8/2021.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//


import UIKit

class PresentationController: UIPresentationController {
    
    private let viewBg: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        viewBg = UIView()
        viewBg.backgroundColor = UIColor.black
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        viewBg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.viewBg.addGestureRecognizer(tapGestureRecognizer)
        self.viewBg.isUserInteractionEnabled = true
    }
    
    override func presentationTransitionWillBegin() {
        self.viewBg.alpha = 0
        self.containerView?.addSubview(viewBg)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.viewBg.alpha = 0.6
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.viewBg.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.viewBg.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.layer.cornerRadius = 20.0
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        viewBg.frame = containerView!.bounds
    }
    
    @objc private  func dismissController(){
        self.presentedViewController.dismiss(animated: true)
    }
}
