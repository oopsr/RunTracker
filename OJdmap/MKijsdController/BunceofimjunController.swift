//
//  BunceofimjunController.swift
//  InfinityTracker
//
//  Created by Alex on 31/08/2017.
//  Copyright © 2017 AleksZilla. All rights reserved.
//

import UIKit
import CoreLocation
import MBLibrary
import StoreKit

class BunceofimjunController: UIViewController {
	
	@IBOutlet weak var asdgadgasdgasdgriesLabel: UILabel!
	@IBOutlet weak var linjuhydsasdLabel: UILabel!
	@IBOutlet weak var bfdsfggggsgeView: UIImageView!
	@IBOutlet weak var rdsgsadfstorysadfsafdButton: UIButton!
	@IBOutlet weak var minjuhghhjsdNHhutton: UIButton!
	@IBOutlet weak var ninjuhyhhIOmjkdsctivityLbl: UILabel!
	
	private let minkujhdsdSegueIddentifier = "minkujhdsdSegueIddentifier"
	private var minjuyhgdsdsdType = PJHHJJJSDrences.minjuyhgdsdsdType
	
	private var lminjuhhsdsdEnabled = false
	private var locManager: CLLocationManager!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		lomniujhofunceRunButton()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		minjuhyhhjjjofkimndeGradient()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		jinlokijnhuhshjjdsdPermission()
		sminjhjjjhasdfsdfsfViews()
		asdfasdfasdvgwqewqeweewdNavigationBar()
	}
	
	// MARK: - Permission Management
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		MKjjjkskdsddssdKitManager.requestAuthorization()
		
		if #available(iOS 10.3, *) {
			guard PJHHJJJSDrences.reviewRequestCounter >= PJHHJJJSDrences.reviewRequestThreshold else {
				return
			}
			
			SKStoreReviewController.requestReview()
		}
	}
	
	func jinlokijnhuhshjjdsdPermission(updateView: Bool = false) {
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .notDetermined:
				if locManager == nil {
					DispatchQueue.main.async {
						self.locManager = CLLocationManager()
						self.locManager.delegate = self
						self.locManager.requestWhenInUseAuthorization()
					}
				}
				fallthrough
			case .restricted, .denied:
				lminjuhhsdsdEnabled = false
			case .authorizedAlways, .authorizedWhenInUse:
				lminjuhhsdsdEnabled = true
			}
		} else {
			lminjuhhsdsdEnabled = false
		}
		
		if updateView {
			sminjhjjjhasdfsdfsfViews()
		}
	}
	
	// MARK: - UI Management
	
	private func minjuhyhhjjjofkimndeGradient() {
		let mikjkjhyjjshjjjdsdtLayer = CAGradientLayer()
		mikjkjhyjjshjjjdsdtLayer.colors = [Londpradarance.lokndinedsdDark.cgColor, Londpradarance.lineokdeLight.cgColor]
		mikjkjhyjjshjjjdsdtLayer.startPoint = CGPoint(x: 0, y: 0)
		mikjkjhyjjshjjjdsdtLayer.endPoint = CGPoint(x: 1, y: 0)
		view.layer.insertSublayer(mikjkjhyjjshjjjdsdtLayer, at: 0)
		mikjkjhyjjshjjjdsdtLayer.frame = view.bounds
	}
	
	private func sminjhjjjhasdfsdfsfViews() {
		bfdsfggggsgeView.layer.masksToBounds = true
		bfdsfggggsgeView.layer.cornerRadius = bfdsfggggsgeView.frame.width/2
		
		minjuhghhjsdNHhutton.layer.masksToBounds = true
		minjuhghhjsdNHhutton.layer.cornerRadius = minjuhghhjsdNHhutton.frame.height/2
		minjuhghhjsdNHhutton.alpha = lminjuhhsdsdEnabled ? 1 : 0.25
		
		linjuhydsasdLabel.text = Londpradarance.format(distance: nil, addUnit: false)
		asdgadgasdgasdgriesLabel.text = Londpradarance.format(calories: nil, addUnit: false)
		MKjjjkskdsddssdKitManager.getsdfasdfsdfStatistics { (d, c) in
			DispatchQueue.main.async {
				self.linjuhydsasdLabel.text = Londpradarance.format(distance: d, addUnit: false)
				self.asdgadgasdgasdgriesLabel.text = Londpradarance.format(calories: c, addUnit: false)
			}
		}
		
	}
	
	private func asdfasdfasdvgwqewqeweewdNavigationBar() {
		Londpradarance.asdfasdfasdvgwqewqeweewdNavigationBar(navigationController)
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	private func lomniujhofunceRunButton() {
		minjuhghhjsdNHhutton.setTitle(NSLocalizedString("NEW_\(minjuyhgdsdsdType.localizable)", comment: "New run/walk"), for: [])
		ninjuhyhhIOmjkdsctivityLbl.text = NSLocalizedString("LONG_PRESS_CHANGE_\(minjuyhgdsdsdType.hgehgnextsdafasdfActivity.localizable)", comment: "Long press to change")
	}
	
	// MARK: - Activity Type
	
	@IBAction func tndsgasgfasfctivityTfsdfaype(_ sender: UILongPressGestureRecognizer) {
		guard sender.state == .began else {
			return
		}
		
		minjuyhgdsdsdType = minjuyhgdsdsdType.hgehgnextsdafasdfActivity
		PJHHJJJSDrences.minjuyhgdsdsdType = self.minjuyhgdsdsdType
		lomniujhofunceRunButton()
	}
	
	// MARK: - Navigation
	
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if identifier == minkujhdsdSegueIddentifier && !lminjuhhsdsdEnabled {
			let alert = UIAlertController(title: NSLocalizedString("LOCATION_REQUIRED", comment: "Need gps"), message: NSLocalizedString("LOCATION_REQUIRED_TEXT", comment: "Need gps desc"), preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: NSLocalizedString("LOCATION_SETTINGS_OPEN", comment: "Open settings"), style: .default) { _ in
				if let bundleID = Bundle.main.bundleIdentifier, let settingsURL = URL(string: UIApplication.openSettingsURLString + bundleID) {
					UIApplication.shared.open(settingsURL)
				}
			})
			alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL", comment: "Cancel"), style: .cancel))
			
			self.present(alert, animated: true)
			return false
		}
		
		return true
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let segueID = segue.identifier else {
			return
		}
		
		switch segueID {
		case minkujhdsdSegueIddentifier:
			guard let minkjuhsdController = segue.destination as? UINavigationController, let kokkjjjjsdgweeController = minkjuhsdController.viewControllers.first as? KinjundofoikjjkController  else {
				return
			}
			
			kokkjjjjsdgweeController.ofkiunnijuhjljajdfDelegate = self
			kokkjjjjsdgweeController.activityType = minjuyhgdsdsdType
			
		case "updateWeight":
			let kinokdest = segue.destination
			PopoverController.preparePresentation(for: kinokdest)
			kinokdest.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
			kinokdest.popoverPresentationController?.sourceView = self.view
			kinokdest.popoverPresentationController?.canOverlapSourceViewRect = true
			
		default:
			break
		}
	}
	
}

// MARK: - KinderDelegate

extension BunceofimjunController: KinderDelegate {
	
	func minjuhyghsdsddDismiss(_ viewController: UIViewController) {
		viewController.dismiss(animated: true, completion: nil)
	}
	
}

// MARK: - CLLocationManagerDelegate

extension BunceofimjunController: CLLocationManagerDelegate {
	
	func okijujhjjjhjsdsdManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .notDetermined {
			return
		}
		
		self.lminjuhhsdsdEnabled = status == .authorizedAlways || status == .authorizedWhenInUse
		self.sminjhjjjhasdfsdfsfViews()
		self.locManager = nil
	}
	
}
