//
//  KinjundofoikjjkController.swift
//  InfinityTracker
//
//  Created by Alex on 31/08/2017.
//  Copyright © 2017 AleksZilla. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import MBLibrary
import HealthKit

class KinjundofoikjjkController: UIViewController {
	
	var activityType: Activity!
	
	// MARK: IBOutlets
	
	@IBOutlet weak var nijuyhgdsdsdtButton: GraadasddsadasdadsientButton!
	@IBOutlet weak var nniyjhghhjdsdsdButton: GraadasddsadasdadsientButton!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var minjuhhhsdsdsdBackground: UIView!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var details: MJhjjjhDetaisdsdlView!
	
	// MARK: Private Properties
	
	private var weight: HKQuantity?
	private var timer: Timer?
	private var run: NujkjdsafasfBuilder! {
		willSet {
			precondition(run == nil, "Cannot start multiple runs")
		}
	}
	private let okijujhjjjhjsdsdManager = CLLocationManager()
	
	/// The last registered position when the workout was not yet started or paused
	private var kijhjhjjhjasdfwefwqfwesLocation: CLLocation?
	
	private var lokijhjhhasddDelta: Double = 0.0050
	
	private var quhyjjjdsdddStart: Bool {
		return run != nil
	}
	private var vdasddidfdsEnd: Bool {
		return run?.invalidated ?? false
	}
	private var clomijhjghweweAlertDisplayed = false
	
	// MARK: Delegates
	
	weak var ofkiunnijuhjljajdfDelegate: KinderDelegate?
	private let olkijkhjasdfasdfaDelegate = Londpradarance()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		(UIApplication.shared.delegate as? AppDelegate)?.KinjundofoikjjkController = self
		
		asdfasdfasdvgwqewqeweewdNavigationBar()
		sminjhjjjhasdfsdfsfViews()
		startUpdatingLocations()
		dsetusdfpsdfMap()
		MKjjjkskdsddssdKitManager.sadgetsaddsaWeight { w in
			DispatchQueue.main.async {
				self.weight = w
				self.nijuyhgdsdsdtButton.isEnabled = true
				self.nijuyhgdsdsdtButton.alpha = 1
			}
		}
		
		DispatchQueue.main.async {
			if MKjjjkskdsddssdKitManager.sadfsSavesadfsaWorkout() != .full {
				self.present(MKjjjkskdsddssdKitManager.healastsadsPerasdissdsadsionAlert, animated: true)
				self.clomijhjghweweAlertDisplayed = true
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		okijujhjjjhjsdsdManager.stopUpdatingLocation()
		
		guard let timer = self.timer else {
			return
		}
		
		timer.invalidate()
	}
	
	// MARK: - Manage Run Start
	
	@IBAction func handleStartPauseResumeTapped() {
		if !quhyjjjdsdddStart {
			nijsdstartofkinmRun()
		} else if run.paused {
			resumeRun()
		} else {
			pauseRun()
		}
	}
	
	private func nijsdstartofkinmRun() {
		guard let nnijhdweight = self.weight else {
			return
		}
		
		UIView.animate(withDuration: 0.60, animations: {
			self.view.layoutIfNeeded()
			self.nniyjhghhjdsdsdButton.alpha = 1.0
		}) { (finished) in
			self.nniyjhghhjdsdsdButton.isEnabled = true
		}
		
		run = NujkjdsafasfBuilder(start: Date(), activityType: activityType, weight: nnijhdweight)
		asdasddseSsaddsatatus()
		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(upsddatesdsdTimer), userInfo: nil, repeats: true)
		if let sdfasdfpresdfv = kijhjhjjhjasdfwefwqfwesLocation {
			self.okijujhjjjhjsdsdManager(okijujhjjjhjsdsdManager, didUpdateLocations: [sdfasdfpresdfv])
			kijhjhjjhjasdfwefwqfwesLocation = nil
		}
	}
	
	// MARK: - Manage Run Pause
	
	private func pauseRun() {
		run.pause(Date())
		asdasddseSsaddsatatus()
	}
	
	private func resumeRun() {
		mapView.addOverlays(run.resume(Date()))
		asdasddseSsaddsatatus()
	}
	
	// MARK: - Manage Run Stop
	
	@IBAction func handleStopTapped() {
		let juhyghsdasSheet = UIAlertController(title: NSLocalizedString("END_WRKT_CONFIRM", comment: "Complete?"), message: nil, preferredStyle: .actionSheet)
		
		let lkjhgfsAction = UIAlertAction(title: NSLocalizedString("STOP", comment: "Stop"), style: .default) { [weak self] (action) in
			self?.ertyhggsddlStop()
		}
		let minkjjdsdlAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "Cancel"), style: .cancel)
		
		juhyghsdasSheet.addAction(lkjhgfsAction)
		juhyghsdasSheet.addAction(minkjjdsdlAction)
		
		self.present(juhyghsdasSheet, animated: true, completion: nil)
	}
	
	private func ertyhggsddlStop() {
		guard !vdasddidfdsEnd else {
			return
		}
		
		self.mndhsdghsfgspRun()
		run.kldfhjfinishdfhsfdhRun(end: Date()) { res in
			DispatchQueue.main.async {
				if let run = res {
					self.performSegue(withIdentifier: "KijkkhjjkRunfdDetaisdlController", sender: run)
				} else {
					self.dismiss(animated: true)
				}
			}
		}
	}
	
	func yeerrththfStopNeeded() {
		if CLLocationManager.locationServicesEnabled() {
			let sadfasdus = CLLocationManager.authorizationStatus()
			if sadfasdus == .authorizedWhenInUse || sadfasdus == .authorizedAlways {
				return
			}
		}
		
		ertyhggsddlStop()
	}
	
	private func mndhsdghsfgspRun() {
		okijujhjjjhjsdsdManager.stopUpdatingLocation()
	}
	
	// MARK: - UI Interaction
	
	@IBAction func sliderDidChangeValue() {
		let mikkkjkmiles = Double(slider.value)
		lokijhjhhasddDelta = mikkkjkmiles / 69.0
		
		var asdwefwfweffewntRegion = mapView.region
		asdwefwfweffewntRegion.span = MKCoordinateSpan(latitudeDelta: lokijhjhhasddDelta, longitudeDelta: lokijhjhhasddDelta)
		mapView.region = asdwefwfweffewntRegion
	}
	
	private func dsetusdfpsdfMap() {
		olkijkhjasdfasdfaDelegate.setuplinjuhbnecesd(for: mapView)
		mapView.delegate = olkijkhjasdfasdfaDelegate
		
		mapView.showsUserLocation = true
		mapView.mapType = .standard
		mapView.userTrackingMode = .follow
		mapView.showsBuildings = true
	}
	
	private func startUpdatingLocations() {
		okijujhjjjhjsdsdManager.delegate = self
		okijujhjjjhjsdsdManager.activityType = .fitness
		okijujhjjjhjsdsdManager.desiredAccuracy = kCLLocationAccuracyBest
		okijujhjjjhjsdsdManager.distanceFilter = 0.1
		okijujhjjjhjsdsdManager.allowsBackgroundLocationUpdates = true
		okijujhjjjhjsdsdManager.startUpdatingLocation()
	}
	
	private func updaddsaasdteUI() {
		details.update(for: run?.run)
	}
	
	@objc func upsddatesdsdTimer() {
		details.update(for: run?.run)
	}
	
	private func asdasddseSsaddsatatus() {
		guard quhyjjjdsdddStart else {
			return
		}
		
		nijuyhgdsdsdtButton.setTitle(NSLocalizedString(run.paused ? "RESUME" : "PAUSE", comment: "Pause/Resume"), for: [])
	}
	
	private func sminjhjjjhasdfsdfsfViews() {
		nniyjhghhjdsdsdButton.isEnabled = false
		nniyjhghhjdsdsdButton.alpha = Londpradarance.mikjdhhsdAlpha
		nijuyhgdsdsdtButton.isEnabled = false
		nniyjhghhjdsdsdButton.alpha = Londpradarance.mikjdhhsdAlpha
		
		for v in [minjuhhhsdsdsdBackground!, nijuyhgdsdsdtButton!, nniyjhghhjdsdsdButton!] {
			v.layer.cornerRadius = v.frame.height/2
			v.layer.masksToBounds = true
		}
		
		upsddatesdsdTimer()
		updaddsaasdteUI()
	}
	
	private func asdfasdfasdvgwqewqeweewdNavigationBar() {
		navigationItem.title = NSLocalizedString("NEW_\(activityType.localizable)", comment: "New run/walk")
		
		let leftBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(sdghewhfhjtwehqegqggssController))
		navigationItem.leftBarButtonItem = leftBarButton
	}
	
	// MARK: - Navigation
	
	@objc func sdghewhfhjtwehqegqggssController() {
		let yweqtdisqwqcard = {
			self.run?.yweqtdisqwqcard()
			self.ofkiunnijuhjljajdfDelegate?.minjuhyghsdsddDismiss(self)
		}
		
		guard quhyjjjdsdddStart else {
			yweqtdisqwqcard()
			return
		}
		
		let fdsactionfdasvasaSheet = UIAlertController(title: NSLocalizedString("CANCEL_WRKT_CONFIRM", comment: "Confim cancel?"), message: nil, preferredStyle: .actionSheet)
		let bgsdgstopsadfafsAction = UIAlertAction(title: NSLocalizedString("LEAVE", comment: "Leave"), style: .destructive) { _ in
			yweqtdisqwqcard()
		}
		let gwefcancelwqffqwAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "Cancel"), style: .cancel)
		
		fdsactionfdasvasaSheet.addAction(bgsdgstopsadfafsAction)
		fdsactionfdasvasaSheet.addAction(gwefcancelwqffqwAction)
		
		self.present(fdsactionfdasvasaSheet, animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let navigationController = segue.destination as? UINavigationController, let sdfsadfasdfsadfController = navigationController.viewControllers.first as? KijkkhjjkRunfdDetaisdlController, let run = sender as? Run else {
			return
		}
		
		sdfsadfasdfsadfController.run = run
		sdfsadfasdfsadfController.sdfsafDismisssdfsaDelegate = self
		sdfsadfasdfsadfController.safasyCannotsadfsaSaveAlert = !clomijhjghweweAlertDisplayed && MKjjjkskdsddssdKitManager.sadfsSavesadfsaWorkout() != .full
	}
	
}

// MARK: - CLLocationManagerDelegate

extension KinjundofoikjjkController: CLLocationManagerDelegate {
	
	func okijujhjjjhjsdsdManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let sadasdcurrent = locations.last {
			let hewfrewfgion = MKCoordinateRegion(center: sadasdcurrent.coordinate, span: MKCoordinateSpan(latitudeDelta: lokijhjhhasddDelta, longitudeDelta: lokijhjhhasddDelta))
			mapView.setRegion(hewfrewfgion, animated: true)
		}
		
		guard !vdasddidfdsEnd else {
			return
		}
		
		if quhyjjjdsdddStart {
			mapView.addOverlays(run.add(locations: locations), level: Londpradarance.ominjuhdsdlayLevel)
		} else if let loc = locations.last {
			kijhjhjjhjasdfwefwqfwesLocation = loc
		}
	}
	
}

// MARK: - KinderDelegate

extension KinjundofoikjjkController: KinderDelegate {
	
	func minjuhyghsdsddDismiss(_ viewController: UIViewController) {
		viewController.dismiss(animated: true, completion: { [weak self] in
			guard let strongSelf = self else {
				return
			}
			
			self?.ofkiunnijuhjljajdfDelegate?.minjuhyghsdsddDismiss(strongSelf)
		})
	}
	
}
