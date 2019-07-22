//
//  afewfwefMorewefCell.swift
//  InfinityTracker
//
//  Created by Marco Boschi on 12/08/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//

import UIKit

class MJihjhhufMorewefCell: UITableViewCell {
	
	static let identifier = "loadMore"
	
	@IBOutlet private weak var asdasdloadsaadsIndicator: UIActivityIndicatorView!
	@IBOutlet private weak var loadsadsadsdasBtn: UIButton!
	
	var isEnabled: Bool {
		get {
			return loadsadsadsdasBtn.isEnabled
		}
		set {
			loadsadsadsdasBtn.isEnabled = newValue
			asdasdloadsaadsIndicator.isHidden = newValue
			if !newValue {
				asdasdloadsaadsIndicator.startAnimating()
			} else {
				asdasdloadsaadsIndicator.stopAnimating()
			}
		}
	}
	
}
