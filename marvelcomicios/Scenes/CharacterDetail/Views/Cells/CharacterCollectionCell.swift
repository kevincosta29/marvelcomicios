//
//  CharacterCollectionCell.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 30/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import UIKit

class CharacterCollectionCell: UICollectionViewCell {
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgContent: UIImageView!
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    private var controller: UIViewController!
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    static let id = "CharacterCollectionCell"
    static let nib = UINib(nibName: id, bundle: Bundle(for: CharacterCollectionCell.self))
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isHighlighted: Bool {
        didSet {
            viewContent.animateViewCellTap(isHighlighted: isHighlighted)
        }
    }
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    func configCellWithComic(_ comic: Comic, cnt: UIViewController) {
        self.controller = cnt
        lblTitle.text = comic.title
        
        if let url = comic.thumbnail?.urlImg {
            imgContent.af.setImage(withURL: url, imageTransition: .crossDissolve(FADE_IN))
            imgContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImg(_:))))
        } else {
            imgContent.image = UIImage()
        }
    }
    
    func configCellWithSerie(_ serie: Serie, cnt: UIViewController) {
        self.controller = cnt
        lblTitle.text = serie.title
        
        if let url = serie.thumbnail?.urlImg {
            imgContent.af.setImage(withURL: url, imageTransition: .crossDissolve(FADE_IN))
            imgContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImg(_:))))
        } else {
            imgContent.image = UIImage()
        }
    }
    
    @objc private func showImg(_ sender: UITapGestureRecognizer) {
        if let vc = controller as? BaseC, let img = (sender.view as? UIImageView)?.image {
            let imgVC = ImageGalleryC(arrayImg: [img], currentIndex: 0)
            vc.showControllerEraseOut(vc: imgVC)
        }
    }

}
