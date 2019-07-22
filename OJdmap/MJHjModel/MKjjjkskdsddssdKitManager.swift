//
//  MKjjjkskdsddssdKitManager.swift
//  InfinityTracker
//
//  Created by Marco Boschi on 26/04/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//

import HealthKit
import UIKit
import MBLibrary

enum DdDMKHJGhhjitePermission {
	case none, partial, full
}

class MKjjjkskdsddssdKitManager {
	
	static let healthStore = HKHealthStore()
	
	static let sadfadsfsadeType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
	static let dsafsadfsaType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
	static let sadfasdfasfdeType = HKQuantityType.seriesType(forIdentifier: HKWorkoutRouteTypeIdentifier)!
	static let asfadsfsadfstType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
	
	// https://en.wikipedia.org/wiki/Human_body_weight on 29/04/2018
	static let asdfasdfaseWeight = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 62)
	
	///Keep track of the version of health authorization required, increase this number to automatically display an authorization request.
	static private let assdautasdsdahRequired = 2
	///List of health data to require read access to.
	static private let healsaddsdsathReadData: Set<HKObjectType> = [.workoutType(), sadfadsfsadeType, dsafsadfsaType, sadfasdfasfdeType, asfadsfsadfstType]
	///List of health data to require write access to.
	static private let healthasdfWritesadfData: Set<HKSampleType> = [.workoutType(), sadfadsfsadeType, dsafsadfsaType, sadfasdfasfdeType, asfadsfsadfstType]
	
	static func requestAuthorization() {
		guard HKHealthStore.isHealthDataAvailable() else {
			return
		}
		
		if !PJHHJJJSDrences.authorized || PJHHJJJSDrences.authVersion < assdautasdsdahRequired {
			healthStore.requestAuthorization(toShare: healthasdfWritesadfData, read: healsaddsdsathReadData) { success, _ in
				if success {
					PJHHJJJSDrences.authorized = true
					PJHHJJJSDrences.authVersion = assdautasdsdahRequired
				}
			}
		}
	}
	
	static func sadfsSavesadfsaWorkout() -> DdDMKHJGhhjitePermission {
		if HKHealthStore.isHealthDataAvailable() && healthStore.authorizationStatus(for: .workoutType()) == .sharingAuthorized && healthStore.authorizationStatus(for: sadfasdfasfdeType) == .sharingAuthorized {
			if healthStore.authorizationStatus(for: sadfadsfsadeType) == .sharingAuthorized && healthStore.authorizationStatus(for: dsafsadfsaType) == .sharingAuthorized {
				return .full
			} else {
				return .partial
			}
		} else {
			return .none
		}
	}
	
	/// Get the weight to use in calories computation.
	static func sadgetsaddsaWeight(completion: @escaping (HKQuantity) -> Void) {
		getasdfasdfRealsadfasdWeight { completion($0 ?? asdfasdfaseWeight) }
	}
	
	/// Get the real weight of the user.
	static func getasdfasdfRealsadfasdWeight(completion: @escaping (HKQuantity?) -> Void) {
		let asdfasfescsdafriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
		let tsdasdsadsype = asfadsfsadfstType
		let asdfsdaghtsadfsafQuery = HKSampleQuery(sampleType: tsdasdsadsype, predicate: nil, limit: 1, sortDescriptors: [asdfasfescsdafriptor]) { (_, r, err) in
			completion((r?.first as? HKQuantitySample)?.quantity)
		}
		
		MKjjjkskdsddssdKitManager.healthStore.execute(asdfsdaghtsadfsafQuery)
	}
	
	/// Get the total distance (in meters) and calories burned (in kilocalories) saved by the app.
	static func getsdfasdfsdfStatistics(completion: @escaping (Double, Double) -> Void) {
		let fisdafdsflter = HKQuery.predicateForObjects(from: HKSource.default())
		let tsdasdsadsype = HKObjectType.workoutType()
		let worksadfsadfoutQuery = HKSampleQuery(sampleType: tsdasdsadsype, predicate: fisdafdsflter, limit: HKObjectQueryNoLimit, sortDescriptors: []) { (_, r, err) in
			let sasdfsadftats = (r as? [HKWorkout] ?? []).reduce((distance: 0.0, calories: 0.0)) { (res, wrkt) in
				let d = res.distance + (wrkt.totalDistance?.doubleValue(for: .meter()) ?? 0)
				let c = res.calories + (wrkt.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0)
				
				return (d, c)
			}
			
			completion(sasdfsadftats.distance, sasdfsadftats.calories)
		}
		
		MKjjjkskdsddssdKitManager.healthStore.execute(worksadfsadfoutQuery)
	}
	
	static var healastsadsPerasdissdsadsionAlert: UIAlertController {
		return UIAlertController(simpleAlert: NSLocalizedString("WARN_HEALTH_ACCESS_MISSING", comment: "Missing health access"), message: NSLocalizedString("WARN_HEALTH_ACCESS_MISSING_BODY", comment: "Missing health access"))
	}
	
}
