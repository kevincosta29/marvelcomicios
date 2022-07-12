//
//  CharacterContentCell.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 30/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import Foundation
import UIKit

class CharacterContentCell: UITableViewCell {
	
	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(CharacterCollectionCell.nib, forCellWithReuseIdentifier: CharacterCollectionCell.id)
        }
    }
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	private var controller: UIViewController!
    private var arrayComics: [Comic] = []
    private var arraySeries: [Serie] = []
    private var section: CharacterDetailSection!
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	static let id = "CharacterContentCell"
    static let nib = UINib(nibName: id, bundle: Bundle(for: CharacterContentCell.self))
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	override func awakeFromNib() {
		super.awakeFromNib()
        
        collectionView.register(CharacterCollectionCell.nib, forCellWithReuseIdentifier: CharacterCollectionCell.id)
        let layoutPendingForms: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPendingForms.scrollDirection = .horizontal
        layoutPendingForms.minimumInteritemSpacing = 0
        layoutPendingForms.minimumLineSpacing = 0
        collectionView.reloadData()
        collectionView!.collectionViewLayout = layoutPendingForms
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.left = 10
        collectionView.contentInset.right = 10
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
	
    func configCellWithComics(_ arrayComics: [Comic], cnt: UIViewController) {
        self.controller = cnt
        self.section = .comics
        self.arrayComics = arrayComics
        
        lblTitle.text = "character.section.comics".localized()
        collectionView.reloadData()
    }
    
    func configCellWithSeries(_ arraySeries: [Serie], cnt: UIViewController) {
        self.controller = cnt
        self.section = .series
        self.arraySeries = arraySeries
        
        lblTitle.text = "character.section.series".localized()
        collectionView.reloadData()
    }
	
}

extension CharacterContentCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.section {
        case .comics:
            return arrayComics.count
        case .series:
            return arraySeries.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionCell.id, for: indexPath) as? CharacterCollectionCell else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .comics:
            let object = arrayComics[indexPath.row]
            cell.configCellWithComic(object, cnt: controller)
        case .series:
            let object = arraySeries[indexPath.row]
            cell.configCellWithSerie(object, cnt: controller)
        default:
            break
        }

        cell.needsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch section {
        case .comics:
            let comic = arrayComics[indexPath.row]
            let vc = ModalComicC(comic: comic)
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            self.controller.present(vc, animated: true)
        default:
            break
        }
    }
    
}

extension CharacterContentCell: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
