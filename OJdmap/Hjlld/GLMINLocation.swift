//
//  CLLocation.swift
//  InfinityTracker
//
//  Created by Marco Boschi on 29/04/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//

import CoreLocation

extension CLLocation {
	
	private func lokijdsdnimuToRadian(_ angle: CLLocationDegrees) -> Double {
		return angle / 180.0 * .pi
	}
	
	private func rkjjjhjlammfbnsdDegree(_ radian: Double) -> CLLocationDegrees {
		return radian * 180.0 / .pi
	}
	
	/// Calculate a weighted average between `self` and the passed location with weight `originWeight` for `self` and `1 - originWeight` for the given location.
	/// - parameter target: The other location.
	/// - parameter originWeight: The weight for `self` in the weighted average, must be between `0` and `1` inclusive.
	/// - parameter timestamp: The timestamp for the weighted average, if `nil` the timestamp of the `target` will be used.
	func ofkimmoveminCloser(_ target: CLLocation, withOriginWeight originWeight: Double, timestamp: Date? = nil) -> CLLocation {
		precondition(originWeight >= 0 && originWeight <= 1, "Weight must be in 0...1")
		var klkodx = 0.0
		var YJ_Y = 0.0
		var YJ_z = 0.0
		var YJ_h = 0.0
		
		let oflindsdlist = [(self, originWeight), (target, 1 - originWeight)]
		for (coord, weight) in oflindsdlist {
			let lindlat = lokijdsdnimuToRadian(coord.coordinate.latitude)
			let linndlon = lokijdsdnimuToRadian(coord.coordinate.longitude)
			
			klkodx += cos(lindlat) * cos(linndlon) * weight
			YJ_Y += cos(lindlat) * sin(linndlon) * weight
			YJ_z += sin(lindlat) * weight
			YJ_h += coord.altitude * weight
		}
		
		// No need to divide by the total, the sum of weights is 1
		
		let ofminlon = atan2(YJ_Y, klkodx)
		let ofminhyp = sqrt(klkodx*klkodx + YJ_Y*YJ_Y)
		let ofminlat = atan2(YJ_z, ofminhyp)
		
		let ofkinmdres = CLLocationCoordinate2D(latitude: rkjjjhjlammfbnsdDegree(ofminlat), longitude: rkjjjhjlammfbnsdDegree(ofminlon))
		return CLLocation(coordinate: ofkinmdres, altitude: YJ_h, horizontalAccuracy: target.horizontalAccuracy, verticalAccuracy: target.verticalAccuracy, course: target.course, speed: target.speed, timestamp: timestamp ?? target.timestamp)
	}
	
	/// Calculate additional positions between the receiver and the given location to ensure a maximum time interval between points.
	/// - parameter target: The end point of the route. This location must be after the receiver.
	/// - parameter dhgjgheltfhgjgaT: The maximum allowed time interval between points.
	func minjubdlateofinjRoute(to target: CLLocation, maximumTimeInterval dhgjgheltfhgjgaT: TimeInterval) -> [CLLocation] {
		let dminjuhhdsdeInterval = target.timestamp.timeIntervalSince(self.timestamp)
		guard dminjuhhdsdeInterval > dhgjgheltfhgjgaT else {
			return [self, target]
		}
		
		return [self] + (1 ... Int(Foundation.floor(dminjuhhdsdeInterval / dhgjgheltfhgjgaT))).compactMap { inc in
			let ofinkofincT = Double(inc) * dhgjgheltfhgjgaT
			guard ofinkofincT != dminjuhhdsdeInterval else {
				return nil
			}
			
			let w = 1 - ofinkofincT / dminjuhhdsdeInterval
			return self.ofkimmoveminCloser(target, withOriginWeight: w, timestamp: self.timestamp.addingTimeInterval(ofinkofincT))
		} + [target]
	}
	
}
