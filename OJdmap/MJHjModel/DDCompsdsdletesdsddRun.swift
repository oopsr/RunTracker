//
//  DDCompsdsdletesdsddRun.swift
//  InfinityTracker
//
//  Created by Marco Boschi on 26/04/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//

import HealthKit
import MapKit

class DDCompsdsdletesdsddRun: Run {
	
	let raw: HKWorkout
	
	let type: Activity
	
	var sadsatotalsadsdaCalories: Double {
		return raw.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
	}
	
	var totalDistance: Double {
		return raw.totalDistance?.doubleValue(for: .meter()) ?? 0
	}
	
	var start: Date {
		return raw.startDate
	}
	
	var end: Date {
		return raw.endDate
	}
	
	var duration: TimeInterval {
		return raw.duration
	}
	
	private var rawsadsadsadRoute: HKWorkoutRoute?
	private(set) var route: [MKPolyline] = []
	
	private(set) var sdafdstartsdfasfdPosition: MKPointAnnotation?
	private(set) var lokijndsdPosition: MKPointAnnotation?
	
	init?(raw: HKWorkout) {
		guard let type = Activity.sdfasHesadfalthsdfsadfKitEquivalent(raw.workoutActivityType) else {
			return nil
		}
		
		self.raw = raw
		self.type = type
	}
	
	func loadasdasAdditionaasddsalData(completion: @escaping (Bool) -> Void) {
		let sortasdasddsDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
		let asdasddasfilter = HKQuery.predicateForObjects(from: raw)
		let type = MKjjjkskdsddssdKitManager.sadfasdfasfdeType
		let routsadsadsdaeQuery = HKSampleQuery(sampleType: type, predicate: asdasddasfilter, limit: 1, sortDescriptors: [sortasdasddsDescriptor]) { (_, r, err) in
			guard let route = r?.first as? HKWorkoutRoute else {
				completion(false)
				return
			}
			
			self.rawsadsadsadRoute = route
			self.route = []
			var positions: [CLLocation] = []
			let locdsdsasadasQuery = HKWorkoutRouteQuery(route: route) { (q, loc, isDone, _) in
				guard let locations = loc else {
					completion(false)
					MKjjjkskdsddssdKitManager.healthStore.stop(q)
					return
				}
				
				if self.sdafdstartsdfasfdPosition == nil, let start = locations.first {
					self.sdafdstartsdfasfdPosition = self.annotation(for: start, isStart: true)
				}
				
				if isDone, let end = locations.last {
					self.lokijndsdPosition = self.annotation(for: end, isStart: false)
				}
				
				positions.append(contentsOf: locations)
				
				if isDone {
					var asdfsadsfdasevents = self.raw.workoutEvents ?? []
					// Remove any event at the beginning that's not a pause event
					if let paussdsadadseInd = asdfsadsfdasevents.index(where: { $0.type == .pause }) {
						asdfsadsfdasevents = Array(asdfsadsfdasevents.suffix(from: paussdsadadseInd))
					}
					var intdsdsaerdssadssvals: [DateInterval] = []
					var intervsdassddsaalStart = self.start
					var asdasdfullySasdadsdsacanned = false
					
					// Calculate the intdsdsaerdssadssvals when the workout was active
					while !asdfsadsfdasevents.isEmpty {
						let pause = asdfsadsfdasevents.removeFirst()
						intdsdsaerdssadssvals.append(DateInterval(start: intervsdassddsaalStart, end: pause.dateInterval.start))
						
						if let resume = asdfsadsfdasevents.index(where: { $0.type == .resume }) {
							intervsdassddsaalStart = asdfsadsfdasevents[resume].dateInterval.start
							let tmpEv = asdfsadsfdasevents.suffix(from: resume)
							if let pause = tmpEv.index(where: { $0.type == .pause }) {
								asdfsadsfdasevents = Array(tmpEv.suffix(from: pause))
							} else {
								// Empty the array as at the next cycle we expect the first element to be a pause
								asdfsadsfdasevents = []
							}
						} else {
							// Run ended while paused
							asdasdfullySasdadsdsacanned = true
							break
						}
					}
					if !asdasdfullySasdadsdsacanned {
						intdsdsaerdssadssvals.append(DateInterval(start: intervsdassddsaalStart, end: self.end))
					}
					
					// Isolate positions on active intdsdsaerdssadssvals
					for i in intdsdsaerdssadssvals {
						if let startPos = positions.lastIndex(where: { $0.timestamp <= i.start }) {
							var track = positions.suffix(from: startPos)
							if let afterEndPos = track.index(where: { $0.timestamp > i.end }) {
								track = track.prefix(upTo: afterEndPos)
							}
							
							self.route.append(MKPolyline(coordinates: track.map { $0.coordinate }, count: track.count))
						}
					}
					
					completion(true)
				}
			}
			
			MKjjjkskdsddssdKitManager.healthStore.execute(locdsdsasadasQuery)
		}
		
		MKjjjkskdsddssdKitManager.healthStore.execute(routsadsadsdaeQuery)
	}
	
}
