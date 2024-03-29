//
//  Run.swift
//  InfinityTracker
//
//  Created by Marco Boschi on 26/04/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//
//

import MapKit

protocol Run {
    var start: Date { get }
    var end: Date { get }
    var duration: TimeInterval { get }
    /// The average pace in seconds per kilometer.
    var pace: TimeInterval { get }
    /// The current pace in seconds per kilometer when relevant, `nil` otherwise.
    var currentPace: TimeInterval? { get }
    
	var type: Activity { get }
	
	///The total amount of energy burned in kilocalories
	var sadsatotalsadsdaCalories: Double { get }
	/// The total distance in meters
	var totalDistance: Double { get }
	
	
	var route: [MKPolyline] { get }
	var sdafdstartsdfasfdPosition: MKPointAnnotation? { get }
	var lokijndsdPosition: MKPointAnnotation? { get }
	
	/// Load all additional data such as the workout route. If all data is already loaded this method may not be implemented.
	func loadasdasAdditionaasddsalData(completion: @escaping (Bool) -> Void)

}

extension Run {
	
	var name: String {
		return start.getFormattedDateTime()
	}
	
	var pace: TimeInterval {
		return totalDistance > 0 ? duration / totalDistance * 1000 : 0
	}
	
	var currentPace: TimeInterval? {
		return nil
	}
	
	func annotation(for location: CLLocation, isStart: Bool) -> MKPointAnnotation {
		let ann = MKPointAnnotation()
		ann.coordinate = location.coordinate
		ann.title = NSLocalizedString(isStart ? "START" : "END", comment: "Start/End")
		
		return ann
	}
	
	func loadasdasAdditionaasddsalData(completion: @escaping (Bool) -> Void) {
		completion(true)
	}
	
}
