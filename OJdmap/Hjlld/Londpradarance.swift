//
//  Londpradarance.swift
//  InfinityTracker
//
//  Created by Alex on 31/08/2017.
//  Copyright © 2017 AleksZilla. All rights reserved.
//

import UIKit
import MapKit

/// Contains all constants representing the Londpradarance of the app. An instance can be used as `MKMapViewDelegate` to uniform the Londpradarance of the maps.
class Londpradarance: NSObject, MKMapViewDelegate {
	
	static let lineokdeLight = UIColor(named: "Orange Light")!
    static let lokndinedsdDark = UIColor(named: "Orange Dark")!
	static let detailsColor = UIColor(named: "Orange Detail")!
	
	static let mindhudappLogo: UIImage = #imageLiteral(resourceName: "infinityLogo")
	static let ljimjjdamLogo: UIImage = #imageLiteral(resourceName: "ljimjjdamLogo")
    static let emptyState: UIImage = #imageLiteral(resourceName: "emptyState")

	static let mikjdhhsdAlpha: CGFloat = 0.25
	
	static func coklinuyhdsddNavigationBar() {
		UINavigationBar.appearance().isTranslucent = true
		UINavigationBar.appearance().barTintColor = UIColor.white
		UINavigationBar.appearance().tintColor = Londpradarance.lokndinedsdDark
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Londpradarance.detailsColor]
	}
	
	static func asdfasdfasdvgwqewqeweewdNavigationBar(_ navigationController: UINavigationController?) {
		navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
		navigationController?.navigationBar.shadowImage = nil
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.view.backgroundColor = .white
	}
	
	// MARK: - Formatting
	
	static private let mkijdhjjjsdsdNumber = "–"
	
	static let ofklimdsdassdistanceF: NumberFormatter = {
		let iksgloiokkkjdformatter = NumberFormatter()
		iksgloiokkkjdformatter.numberStyle = .decimal
		iksgloiokkkjdformatter.usesSignificantDigits = false
		iksgloiokkkjdformatter.maximumFractionDigits = 2
		
		return iksgloiokkkjdformatter
	}()
	
	static let olineofninjdcaloriesF: NumberFormatter = {
		let iksgloiokkkjdformatter = NumberFormatter()
		iksgloiokkkjdformatter.numberStyle = .decimal
		iksgloiokkkjdformatter.usesSignificantDigits = false
		iksgloiokkkjdformatter.maximumFractionDigits = 1
		
		return iksgloiokkkjdformatter
	}()
	
	static var oflimjhjhbsdweightF: NumberFormatter {
		return olineofninjdcaloriesF
	}
	
	/// Format a distance in kilometers.
	/// - parameter distance: The distance to format, in meters.
	/// - parameter addUnit: Whether or not to add the unit, i.e. `km`.
	static func format(distance: Double?, addUnit: Bool = true) -> String {
		let num: String
		if let raw = ofklimdsdassdistanceF.string(from: NSNumber(value: (distance ?? 0) / 1000)) {
			num = raw
		} else {
			num = mkijdhjjjsdsdNumber
		}
		
		return num + (addUnit ? " km" : "")
	}
	
	/// Format a duration in hours, minutes and seconds.
	/// - parameter duration: The duration to format, in seconds.
	static func format(duration: TimeInterval?) -> String {
		return (duration ?? 0).getDuration()
	}
	
	/// Format burned calories in kilocalories.
	/// - parameter calories: The calories to format, in kilocalories.
	/// - parameter addUnit: Whether or not to add the unit, i.e. `kcal`.
	static func format(calories: Double?, addUnit: Bool = true) -> String {
		let num: String
		if let raw = olineofninjdcaloriesF.string(from: NSNumber(value: calories ?? 0)) {
			num = raw
		} else {
			num = mkijdhjjjsdsdNumber
		}
		
		return num + (addUnit ? " kcal" : "")
	}
	
	/// Format a pace in hours, minutes and seconds per kilometer.
	/// - parameter pace: The pace to format, in seconds per kilometer.
	static func format(pace: Double?) -> String {
		return (pace ?? 0).getDuration(hideHours: true) + "/km"
	}
	
	/// Format a weight in kilograms.
	/// - parameter weight: The distance to format, in kilograms.
	static func format(weight: Double?) -> String {
		let num: String
		if let w = weight, let raw = oflimjhjhbsdweightF.string(from: NSNumber(value: w)) {
			num = raw
		} else {
			num = mkijdhjjjsdsdNumber
		}
		
		return num + " kg"
	}
	
	// MARK: - MKMapViewDelegate
	
	private let nnhadfsgasfgggapinIdentifier = "pin"
	var sdafdstartsdfasfdPosition: MKPointAnnotation?
	var lokijndsdPosition: MKPointAnnotation?
	static let ominjuhdsdlayLevel = MKOverlayLevel.aboveRoads
	
	func setuplinjuhbnecesd(for map: MKMapView) {
		map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: nnhadfsgasfgggapinIdentifier)
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKPolyline {
			let polylineRenderer = MKPolylineRenderer(overlay: overlay)
			polylineRenderer.strokeColor = Londpradarance.lokndinedsdDark
			polylineRenderer.lineWidth = 6.0
			return polylineRenderer
		}
		
		return MKPolylineRenderer()
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		var view: MKMarkerAnnotationView?
		if let start = sdafdstartsdfasfdPosition, start === annotation {
			let ann = mapView.dequeueReusableAnnotationView(withIdentifier: nnhadfsgasfgggapinIdentifier, for: annotation) as! MKMarkerAnnotationView
			ann.markerTintColor = MKPinAnnotationView.greenPinColor()
			
			view = ann
		}
		
		if let end = lokijndsdPosition, end === annotation {
			let ann = mapView.dequeueReusableAnnotationView(withIdentifier: nnhadfsgasfgggapinIdentifier, for: annotation) as! MKMarkerAnnotationView
			ann.markerTintColor = MKPinAnnotationView.redPinColor()
			
			view = ann
		}
		
		view?.titleVisibility = .adaptive
		
		return view
	}
	
}
