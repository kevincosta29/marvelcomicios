//
//  Extensions.swift
//  Marvel Comic
//
//  Created by Kevin Costa on 25/8/21.
//  Copyright © 2021 Kevin Costa. All rights reserved.
//

import UIKit
import Lottie

// MARK: - EXTENSION - UIApplication
extension UIApplication {
	
	// App has more than one window and just want to get topMostViewController of the AppDelegate window.
	var appDelegateWindowTopMostViewController: UIViewController? {
		let delegate = UIApplication.shared.delegate as? AppDelegate
		var topController = delegate?.window?.rootViewController
		while topController?.presentedViewController != nil {
			topController = topController?.presentedViewController
		}
		return topController
	}
    
    func setStatusBar(style: UIStatusBarStyle) {
        if style == .lightContent {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            if #available(iOS 13, *) {
                UIApplication.shared.statusBarStyle = .darkContent
            } else {
                UIApplication.shared.statusBarStyle = .default
            }
        }
    }
}

// MARK: - EXTENSION - UINavigationController
extension UINavigationController {
	
	func hairLine(hide: Bool) {
		//hides hairline at the bottom of the navigationbar
		for subview in self.navigationBar.subviews {
			if subview.isKind(of: UIImageView.self) {
				for hairline in subview.subviews {
					if hairline.isKind(of: UIImageView.self) && hairline.bounds.height <= 1.0 {
						hairline.isHidden = hide
					}
				}
			}
		}
		
	}
}


// MARK: - EXTENSION - UIColor

extension UIColor {
    
    convenience init(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                }
            }
        }
        self.init(Hex: 0xffffff)
    }
	
	convenience init(hexString: String) {
		let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int = UInt64()
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (255, 0, 0, 0)
		}
		self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
	}
	
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(Hex:Int) {
		self.init(red:(Hex >> 16) & 0xff, green:(Hex >> 8) & 0xff, blue:Hex & 0xff)
	}
	
	func isEqualToColor(_ otherColor : UIColor) -> Bool {
		if self == otherColor {
			return true
		}
		
		let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
		let convertColorToRGBSpace : ((_ color : UIColor) -> UIColor?) = { (color) -> UIColor? in
			if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
				let oldComponents = color.cgColor.components
				let components : [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1] ]
				let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
				let colorOut = UIColor(cgColor: colorRef!)
				return colorOut
			}
			else {
				return color;
			}
		}
		
		let selfColor = convertColorToRGBSpace(self)
		let otherColor = convertColorToRGBSpace(otherColor)
		
		if let selfColor = selfColor, let otherColor = otherColor {
			return selfColor.isEqual(otherColor)
		}
		else {
			return false
		}
	}
}

// MARK: - EXTENSION - UIButtons

extension UIButton {
	func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		self.setBackgroundImage(colorImage, for: forState)
	}
	
}

// MARK: - EXTENSION - UIView

public extension UIView {
    
    func addLottie(strName: String = "loading") {
        let animationView = AnimationView(name: strName)
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func animateViewCellTap(isHighlighted: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if isHighlighted {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } else {
                self.transform = .identity
            }
        })
    }
}


// MARK: - EXTENSION - String

extension String {
	
	func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
		return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
	}
	
	func capitalizingFirstLetter() -> String {
		let first = String(prefix(1)).capitalized
		let other = String(dropFirst())
		return first + other
	}
}

// MARK: - EXTENSION - UIScreen

extension UIScreen {
	
	public func getWidth() -> CGFloat {
		return UIScreen.main.bounds.size.width
	}
	
	public func getHeight() -> CGFloat {
		return UIScreen.main.bounds.size.height
	}
	
	public func getDev() -> String
	{
		let isiPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)
		
		if (isiPad) {
			return "tablet"
		}
		else {
			return "phone"
		}
	}
}

public extension UIImage {
	
	convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		guard let cgImage = image!.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}
}

extension UITableView  {
    func addCustomRefresh(action: Selector, target: Any?) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
}
