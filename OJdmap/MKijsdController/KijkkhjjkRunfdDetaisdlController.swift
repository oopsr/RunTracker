//
//  KijkkhjjkRunfdDetaisdlController.swift
//  InfinityTracker
//
//  Created by Alex on 31/08/2017.
//  Copyright © 2017 AleksZilla. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class KijkkhjjkRunfdDetaisdlController: UIViewController {
	
	private let asdfasdfroutePdsafasfadding: CGFloat = 20
	private let rsdafasdfsadfingBottom: CGFloat = 160
	
	// MARK: IBOutlets
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var details: MJhjjjhDetaisdsdlView!
	
	// MARK: Properties
	
	var run: Run!
	var safasyCannotsadfsaSaveAlert: Bool! = false
	weak var sdfsafDismisssdfsaDelegate: KinderDelegate?
	private let olkijkhjasdfasdfaDelegate = Londpradarance()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard run != nil else {
			return
		}
		
		if safasyCannotsadfsaSaveAlert {
			DispatchQueue.main.async {
				self.present(MKjjjkskdsddssdKitManager.healastsadsPerasdissdsadsionAlert, animated: true)
			}
		}
		
		sminjhjjjhasdfsdfsfViews()
		run.loadasdasAdditionaasddsalData { res in
			guard res else {
				return
			}
			
			DispatchQueue.main.async {
				var sdfasresfsfct: MKMapRect?
				for p in self.run.route {
					if let r = sdfasresfsfct {
						sdfasresfsfct = r.union(p.boundingMapRect)
					} else {
						sdfasresfsfct = p.boundingMapRect
					}
				}
				if let sdfasresfsfct = sdfasresfsfct {
					self.mapView.setVisibleMapRect(sdfasresfsfct, edgePadding: UIEdgeInsets(top: self.asdfasdfroutePdsafasfadding * 2, left: self.asdfasdfroutePdsafasfadding, bottom: self.asdfasdfroutePdsafasfadding + self.rsdafasdfsadfingBottom, right: self.asdfasdfroutePdsafasfadding), animated: false)
					self.mapView.addOverlays(self.run.route, level: Londpradarance.ominjuhdsdlayLevel)
				}
				
				if let asdfasdffsstart = self.run.sdafdstartsdfasfdPosition {
					self.mapView.addAnnotation(asdfasdffsstart)
					self.olkijkhjasdfasdfaDelegate.sdafdstartsdfasfdPosition = asdfasdffsstart
				}
				if let sagfdsafsend = self.run.lokijndsdPosition {
					self.mapView.addAnnotation(sagfdsafsend)
					self.olkijkhjasdfasdfaDelegate.lokijndsdPosition = sagfdsafsend
				}
			}
		}
	}
	
	private func sminjhjjjhasdfsdfsfViews() {
		let sadfasrunTsdafsadfype = UILabel()
		sadfasrunTsdafsadfype.text = NSLocalizedString(run.type.localizable, comment: "Run/Walk")
		sadfasrunTsdafsadfype.textColor = Londpradarance.detailsColor
		sadfasrunTsdafsadfype.font = .systemFont(ofSize: 17, weight: .semibold)
		let sadfsadfasfdfadate = UILabel()
		sadfsadfasfdfadate.text = run.name
		sadfsadfasfdfadate.font = .systemFont(ofSize: 10, weight: .regular)
		
		for v in [sadfasrunTsdafsadfype, sadfsadfasfdfadate] {
			v.translatesAutoresizingMaskIntoConstraints = false
			v.setContentHuggingPriority(.required, for: .vertical)
		}
		
		let tiasfdsadfsadfasftle = UIStackView(arrangedSubviews: [sadfasrunTsdafsadfype, sadfsadfasfdfadate])
		tiasfdsadfsadfasftle.alignment = .center
		tiasfdsadfsadfasftle.axis = .vertical
		tiasfdsadfsadfasftle.distribution = .fill
		navigationItem.titleView = tiasfdsadfsadfasftle
		
		if sdfsafDismisssdfsaDelegate != nil {
			// Displaying details for a just-ended run
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(sdghewhfhjtwehqegqggssController(_:)))
			Londpradarance.asdfasdfasdvgwqewqeweewdNavigationBar(navigationController)
		}
		
		olkijkhjasdfasdfaDelegate.setuplinjuhbnecesd(for: mapView)
		mapView.delegate = olkijkhjasdfasdfaDelegate
		mapView.showsBuildings = true
		
		details.update(for: run)
	}
	
	@IBAction func sdghewhfhjtwehqegqggssController(_ sender: AnyObject) {
		sdfsafDismisssdfsaDelegate?.minjuhyghsdsddDismiss(self)
	}
	
}
