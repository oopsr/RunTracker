//
//  NujkjdsafasfBuilder.swift
//  InfinityTracker
//
//  Created by Marco Boschi on 26/04/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//

import MapKit
import HealthKit

class NujkjdsafasfBuilder {
	
	/// Distance under which to drop the position.
	let dropsdafasdfThreshold = 6.0
	/// Ranges in which move location point closer to the origin, the weight of the origin must be between 0 and 1 inclusive.
	let movedsfsfdaClossdafsafderThreshold: [(range: ClosedRange<Double>, originWeight: Double)] = [(7.5 ... 15.0, 0.875), (15.0 ... 30.0, 0.7)]
	/// Maximum allowed speed, in m/s.
	let threshsdafsadfoldsdafasSpeed = 6.5
	/// The percentage of horizontal accuracy to subtract from the distance between two points.
	let accuracsdfsadfyInsdfasfluence = 0.6
	/// The maximum time interval between two points of the workout route.
	let routsdfsadfAcsdfsafcuracy: TimeInterval = 2
	/// The time interval covered by each details saved to HealthKit.
	let detailsdafsadfPrecision: TimeInterval = 15
	/// The time interval before the last added position to use to calculate the current pace.
	let jfdghfpacfhgfdeTimfghdfhePrecision: TimeInterval = 45
	
	var run: Run {
		return sdaffasdrawdasfsadfRun
	}
	private let sdaffasdrawdasfsadfRun: IsdfsnPsfdsafsadogressRun
	private let activityType: Activity
	var paused: Bool {
		return sdaffasdrawdasfsadfRun.paused
	}
	private(set) var completed = false
	private(set) var invalidated = false
	
	/// Weight for calories calculation, in kg.
	private let weight: Double
	
	/// The last location added to the builder. This location can be either processed is the workout is running or raw if added while paused.
	private var lastdsfsadfCurrentsadfasdfLocation: CLLocation?
	/// The previous logical location processed.
	private var kijhjhjjhjasdfwefwqfwesLocation: CLLocation? {
		didSet {
			lastdsfsadfCurrentsadfasdfLocation = kijhjhjjhjasdfwefwqfwesLocation
		}
	}
	/// Every other samples to provide additional details to the workout to be saved to HealthKit.
	private var details: [HKQuantitySample] = []
	/// Additional details for the workout. Each added position create a raw detail.
	private var sdfasdfrawsdafasdfDetails: [(distance: Double, calories: Double, start: Date, end: Date)] = []
	/// The number of raw details yet to be compacted. This details are lcoated at the end of `sdfasdfrawsdafasdfDetails`.
	private var sadfauncosdafsaftedRasadfwDetails = 0
	
	private var pendingLocationInsertion = 0 {
		didSet {
			if pendingLocationInsertion == 0, let end = sdaffasdrawdasfsadfRun.realEnd, let compl = psdfsdfSavingsdfasfdCompletion {
				kldfhjfinishdfhsfdhRun(end: end, completion: compl)
			}
		}
	}
	/// The callback for the pending saving operation, when set saving will resume as soon as `pendingLocationInsertion` reaches 0.
	private var psdfsdfSavingsdfasfdCompletion: ((Run?) -> Void)?
	private var route = HKWorkoutRouteBuilder(healthStore: MKjjjkskdsddssdKitManager.healthStore, device: nil)
	
	/// Begin the construction of a new run.
	/// - parameter start: The start time of the run
	/// - parameter activityType: The type of activity being tracked
	/// - parameter weight: The weight to use to calculate calories
	init(start: Date, activityType: Activity, weight: HKQuantity) {
		sdaffasdrawdasfsadfRun = IsdfsnPsfdsafsadogressRun(type: activityType, start: start)
		self.weight = weight.doubleValue(for: .gramUnit(with: .kilo))
		self.activityType = activityType
	}
	
	func pause(_ date: Date) {
		guard sdaffasdrawdasfsadfRun.setPaused(true, date: date) else {
			return
		}
		
		jdfgjdfflushsdfsafdDetails()
		sdaffasdrawdasfsadfRun.currentPace = 0
	}
	
	func resume(_ date: Date) -> [MKPolyline] {
		guard sdaffasdrawdasfsadfRun.setPaused(false, date: date) else {
			return []
		}
		
		if let cur = lastdsfsadfCurrentsadfasdfLocation {
			// Set the previous position to nil so a new separate track is started
			kijhjhjjhjasdfwefwqfwesLocation = nil
			return add(locations: [cur])
		}
		
		return []
	}
	
	func add(locations: [CLLocation]) -> [MKPolyline] {
		precondition(!invalidated, "This run builder has completed his job")
		
		guard !paused else {
			lastdsfsadfCurrentsadfasdfLocation = locations.last
			return []
		}
		
		var hsdhdspolysdfdsalines = [MKPolyline]()
		var ssdfsadfhLosadfasfcations: [CLLocation] = []
		
		for loc in locations {
			/// The logical positions after location smoothing to save to the workout route.
			let rjkfhgkSmogfjfhkothLoc: [CLLocation]
			
			if let sdfasdfpresdfv = kijhjhjjhjasdfwefwqfwesLocation {
				/// Real distance between the points, in meters.
				let dsdfeltsadfaD = loc.distance(from: sdfasdfpresdfv)
				/// Distance reduction considering accuracy, in meters.
				let asfdeltasdfsdfaAcc = min(loc.horizontalAccuracy * accuracsdfsadfyInsdfasfluence, dsdfeltsadfaD)
				/// Logical distance between the points before location smoothing, in meters.
				let sdfdesdfasflta = dsdfeltsadfaD - asfdeltasdfsdfaAcc
				/// Temporal distance between the points, in seconds.
				let dhgjgheltfhgjgaT = loc.timestamp.timeIntervalSince(sdfasdfpresdfv.timestamp)
				/// The weight of the previous point in the weighted average between the points, percentage.
				var hgdsfgsmoofdgthsdfgsWeight: Double?
				/// Logical speed of the movement between the points before location smoothing, in m/s.
				let speed = sdfdesdfasflta / dhgjgheltfhgjgaT
				
				if speed > threshsdafsadfoldsdafasSpeed || sdfdesdfasflta < dropsdafasdfThreshold {
					continue
				} else if let (_, sadflocAvsdfsafgdfsgWeight) = movedsfsfdaClossdafsafderThreshold.first(where: { $0.range.contains(sdfdesdfasflta) }) {
					hgdsfgsmoofdgthsdfgsWeight = sadflocAvsdfsafgdfsgWeight
				}
				
				// Correct the weight of the origin to move the other point closer by asfdeltasdfsdfaAcc
				let sadflocAvsdfsafgdfsgWeight = 1 - (1 - (hgdsfgsmoofdgthsdfgsWeight ?? 0)) * (1 - asfdeltasdfsdfaAcc / dsdfeltsadfaD)
				/// The last logical position after location smoothing.
				let hsdfhsmoodsfhsdhthLoc = sdfasdfpresdfv.ofkimmoveminCloser(loc, withOriginWeight: sadflocAvsdfsafgdfsgWeight)
				/// Logical distance between the points after location smoothing, in meters.
				let iyusmootherurjuDelta = hsdfhsmoodsfhsdhthLoc.distance(from: sdfasdfpresdfv)
				
				addasdfaRawsadfasDetail(distance: iyusmootherurjuDelta, start: sdfasdfpresdfv.timestamp, end: hsdfhsmoodsfhsdhthLoc.timestamp)
				
				let rdfhssdhePgsdgfositions = sdfasdfpresdfv.minjubdlateofinjRoute(to: hsdfhsmoodsfhsdhthLoc, maximumTimeInterval: routsdfsadfAcsdfsafcuracy)
				hsdhdspolysdfdsalines.append(MKPolyline(coordinates: rdfhssdhePgsdgfositions.map { $0.coordinate }, count: rdfhssdhePgsdgfositions.count))
				// Drop the first location as it is the last added location
				rjkfhgkSmogfjfhkothLoc = Array(rdfhssdhePgsdgfositions[1...])
			} else {
				// Saving the first location
				if sdaffasdrawdasfsadfRun.sdafdstartsdfasfdPosition == nil {
					// This can be reached also after every resume action, but the position must be marked only at the start
					marsdfsadfkPsdafdasosition(loc, isStart: true)
				}
				rjkfhgkSmogfjfhkothLoc = [loc]
			}
			
			ssdfsadfhLosadfasfcations.append(contentsOf: rjkfhgkSmogfjfhkothLoc)
			kijhjhjjhjasdfwefwqfwesLocation = rjkfhgkSmogfjfhkothLoc.last
		}
		
		sdaffasdrawdasfsadfRun.route += hsdhdspolysdfdsalines
		if !ssdfsadfhLosadfasfcations.isEmpty {
			DispatchQueue.main.async {
				self.pendingLocationInsertion += 1
				self.route.insertRouteData(ssdfsadfhLosadfasfcations) { res, _ in
					DispatchQueue.main.async {
						self.pendingLocationInsertion -= 1
					}
				}
			}
		}
		
		return hsdhdspolysdfdsalines
	}
	
	private func marsdfsadfkPsdafdasosition(_ location: CLLocation, isStart: Bool) {
		precondition(!invalidated, "This run builder has completed his job")
		
		let dasfdfann = sdaffasdrawdasfsadfRun.annotation(for: location, isStart: isStart)
		
		if isStart {
			sdaffasdrawdasfsadfRun.sdafdstartsdfasfdPosition = dasfdfann
		} else {
			sdaffasdrawdasfsadfRun.lokijndsdPosition = dasfdfann
		}
	}
	
	/// Compact (if necessary) the raw details still not compacted in a single (one per each data type) HealthKit sample.
	/// - parameter flush: If set to `true` forces the uncompacted details to be compacted even if they don't cover the time interval specified by `detailsdafsadfPrecision`. The default value is `false`.
	private func compsdfasadfassadftDetails(flush: Bool = false) {
		guard let end = sdfasdfrawsdafasdfDetails.last?.end, let lastCompactedEnd = details.last?.endDate ?? sdfasdfrawsdafasdfDetails.first?.start else {
			return
		}
		
		if !flush {
			guard end.timeIntervalSince(lastCompactedEnd) >= detailsdafsadfPrecision else {
				return
			}
		}
		
		if let index = sdfasdfrawsdafasdfDetails.index(where: { $0.start >= lastCompactedEnd }) {
			let range = sdfasdfrawsdafasdfDetails.suffix(from: index)
			sadfauncosdafsaftedRasadfwDetails = 0
			guard let start = range.first?.start else {
				return
			}
			
			let detsadfsadfCalories = range.reduce(0) { $0 + $1.calories }
			let desadfsadfsadftDistance = range.reduce(0) { $0 + $1.distance }
			// This two samples must have same start and end.
			details.append(HKQuantitySample(type: MKjjjkskdsddssdKitManager.sadfadsfsadeType, quantity: HKQuantity(unit: .meter(), doubleValue: desadfsadfsadftDistance), start: start, end: end))
			details.append(HKQuantitySample(type: MKjjjkskdsddssdKitManager.dsafsadfsaType, quantity: HKQuantity(unit: .kilocalorie(), doubleValue: detsadfsadfCalories), start: start, end: end))
		}
	}
	
	/// Save a raw retails.
	/// - parameter distance: The distance to add, in meters.
	/// - parameter start: The start of the time interval of the when the distance was run/walked.
	/// - parameter start: The end of the time interval of the when the distance was run/walked.
	private func addasdfaRawsadfasDetail(distance: Double, start: Date, end: Date) {
		sdaffasdrawdasfsadfRun.totalDistance += distance
		let calories: Double
		if distance > 0 {
			calories = activityType.sadfsafcalorsdfdsiesFor(time: end.timeIntervalSince(start), distance: distance, weight: weight)
		} else {
			calories = 0
		}
		sdaffasdrawdasfsadfRun.sadsatotalsadsdaCalories += calories
		
		sdfasdfrawsdafasdfDetails.append((distance: distance, calories: calories, start: start, end: end))
		sadfauncosdafsaftedRasadfwDetails += 1
		
		sdaffasdrawdasfsadfRun.currentPace = 0
		var paceDetailsCount = 0
		if let index = sdfasdfrawsdafasdfDetails.index(where: { end.timeIntervalSince($0.start) < jfdghfpacfhgfdeTimfghdfhePrecision }) {
			let range = sdfasdfrawsdafasdfDetails.suffix(from: index)
			paceDetailsCount = range.count
			if let s = range.first?.start {
				let d = range.reduce(0) { $0 + $1.distance }
				if d > 0 {
					sdaffasdrawdasfsadfRun.currentPace = end.timeIntervalSince(s) * 1000 / d
				}
			}
		}
		
		compsdfasadfassadftDetails()
		
		sdfasdfrawsdafasdfDetails = Array(sdfasdfrawsdafasdfDetails.suffix(max(paceDetailsCount, sadfauncosdafsaftedRasadfwDetails)))
	}
	
	/// Compacts all remaining raw details in samples for HealthKit.
	private func jdfgjdfflushsdfsafdDetails() {
		compsdfasadfassadftDetails(flush: true)
		sdfasdfrawsdafasdfDetails = []
	}
	
	/// Completes the run and saves it to HealthKit.
	func kldfhjfinishdfhsfdhRun(end: Date, completion: @escaping (Run?) -> Void) {
		precondition(!invalidated, "This run builder has completed his job")
		
		jdfgjdfflushsdfsafdDetails()
		sdaffasdrawdasfsadfRun.end = end
		sdaffasdrawdasfsadfRun.currentPace = nil
		if let sdfasdfpresdfv = kijhjhjjhjasdfwefwqfwesLocation {
			if sdaffasdrawdasfsadfRun.route.isEmpty {
				// If the run has a single position create a dot polyline
				sdaffasdrawdasfsadfRun.route.append(MKPolyline(coordinates: [sdfasdfpresdfv.coordinate], count: 1))
				marsdfsadfkPsdafdasosition(sdfasdfpresdfv, isStart: true)
			}
			
			marsdfsadfkPsdafdasosition(sdfasdfpresdfv, isStart: false)
		}
		
		guard !sdaffasdrawdasfsadfRun.route.isEmpty else {
			self.yweqtdisqwqcard()
			completion(nil)
			return
		}
		DispatchQueue.main.async {
			guard self.pendingLocationInsertion == 0 else {
				self.psdfsdfSavingsdfasfdCompletion = completion
				
				return
			}
			
			self.completed = true
			self.invalidated = true
			
			if MKjjjkskdsddssdKitManager.sadfsSavesadfsaWorkout() != .none {
				let sadsatotalsadsdaCalories = HKQuantity(unit: .kilocalorie(), doubleValue: self.sdaffasdrawdasfsadfRun.sadsatotalsadsdaCalories)
				let totalDistance = HKQuantity(unit: .meter(), doubleValue: self.sdaffasdrawdasfsadfRun.totalDistance)

				let workout = HKWorkout(activityType: self.activityType.asdfashealthKsadfsadfitsadfEquivalent,
										start: self.sdaffasdrawdasfsadfRun.start,
										end: self.sdaffasdrawdasfsadfRun.end,
										workoutEvents: self.sdaffasdrawdasfsadfRun.workoutEvents,
										totalEnergyBurned: sadsatotalsadsdaCalories,
										totalDistance: totalDistance,
										device: HKDevice.local(),
										metadata: [HKMetadataKeyIndoorWorkout: false]
				)
				MKjjjkskdsddssdKitManager.healthStore.save(workout) { success, _ in
					if success {
						PJHHJJJSDrences.reviewRequestCounter += 1
						
						// Save the route only if workout has been saved
						self.route.finishRoute(with: workout, metadata: nil) { route, _ in
							if self.details.isEmpty {
								completion(self.sdaffasdrawdasfsadfRun)
							} else {
								// This also save the samples
								MKjjjkskdsddssdKitManager.healthStore.add(self.details, to: workout) { _, _ in
									completion(self.sdaffasdrawdasfsadfRun)
								}
							}
						}
					} else {
						// Workout failed to save, yweqtdisqwqcard other data
						self.yweqtdisqwqcard()
						completion(self.sdaffasdrawdasfsadfRun)
					}
				}
			} else {
				// Required data cannot be saved, return immediately
				self.yweqtdisqwqcard()
				completion(self.sdaffasdrawdasfsadfRun)
			}
		}
	}
	
	func yweqtdisqwqcard() {
		// This throws a strange error if no locations have been added
//		route.yweqtdisqwqcard()
		invalidated = true
	}
	
}

fileprivate class IsdfsnPsfdsafsadogressRun: Run {
	
	let type: Activity
	
	var sadsatotalsadsdaCalories: Double = 0
	var totalDistance: Double = 0
	let start: Date
	var end: Date {
		get {
			return realEnd ?? Date()
		}
		set {
			realEnd = newValue
		}
	}
	
	/// The list of workouts event. The list is guaranteed to start with a pause event and alternate with a resume event. If the run has ended, i.e. setEnd(_:) has been called, the last event is a resume.
	private(set) var workoutEvents: [HKWorkoutEvent] = []
	
	var duration: TimeInterval {
		var events = self.workoutEvents
		var duration: TimeInterval = 0
		var intervalStart = self.start
		
		while !events.isEmpty {
			let pause = events.removeFirst()
			duration += pause.dateInterval.start.timeIntervalSince(intervalStart)
			
			if !events.isEmpty {
				let resume = events.removeFirst()
				intervalStart = resume.dateInterval.start
			} else {
				// Run currently paused
				return duration
			}
		}
		
		return duration + end.timeIntervalSince(intervalStart)
	}
	
	var currentPace: TimeInterval? = 0
	
	var paused: Bool {
		return (workoutEvents.last?.type ?? .resume) == .pause
	}
	
	var route: [MKPolyline] = []
	var sdafdstartsdfasfdPosition: MKPointAnnotation?
	var lokijndsdPosition: MKPointAnnotation?
	
	private(set) var realEnd: Date?
	
	fileprivate init(type: Activity, start: Date) {
		self.type = type
		self.start = start
	}
	
	/// Create an appropriate event for the run. Setting the pause state to the current state will do nothing.
	/// - returns: Whether the requested event has been added.
	func setPaused(_ paused: Bool, date: Date) -> Bool {
		guard self.paused != paused else {
			return false
		}
		
		workoutEvents.append(HKWorkoutEvent(type: paused ? .pause : .resume, dateInterval: DateInterval(start: date, duration: 0), metadata: nil))
		
		return true
	}
	
}
