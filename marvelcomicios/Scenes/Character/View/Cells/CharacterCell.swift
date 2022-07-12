//
//  CharacterCell.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 30/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class CharacterCell: UITableViewCell {
	
	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
    @IBOutlet weak var imgCharacter: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	private var controller: UIViewController!
    private var character: Character!
    
    static let id = "CharacterCell"
    static let nib = UINib(nibName: id, bundle: Bundle(for: CharacterCell.self))
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	override func awakeFromNib() {
		super.awakeFromNib()
        imgCharacter.layer.cornerRadius = 10.0
	}
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
	}
	
	override var isHighlighted: Bool {
		didSet { }
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	func configCellWithCharacter(_ character: Character, cnt: UIViewController) {
		self.controller = cnt
        self.character = character
        
        lblTitle.text = character.name
        lblTitle.isHidden = character.name == nil || character.name == ""
        lblSubtitle.text = character.description
        lblSubtitle.isHidden = character.description == nil || character.description == ""
        
        if let url = character.thumbnail?.urlImg {
            imgCharacter.af.setImage(withURL: url, imageTransition: .crossDissolve(FADE_IN))
            imgCharacter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImg(_:))))
        } else {
            imgCharacter.image = UIImage()
        }
	}
    
    @objc private func showImg(_ sender: UITapGestureRecognizer) {
        if let vc = controller as? BaseC, let img = (sender.view as? UIImageView)?.image {
            let imgVC = ImageGalleryC(arrayImg: [img], currentIndex: 0)
            vc.showControllerEraseOut(vc: imgVC)
        }
    }
	
}
