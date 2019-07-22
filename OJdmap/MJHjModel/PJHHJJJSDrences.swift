//
//  PJHHJJJSDrences.swift
//  Workout
//
//  Created by Marco Boschi on 03/08/16.
//  Copyright © 2016 Marco Boschi. All rights reserved.
//

import HealthKit
import MBLibrary

fileprivate enum MKUKsdafsafrenceKeys: String, KeyValueStoreKey {
	case authorized = "authorized"
	case authVersion = "authVersion"
	
	case minjuyhgdsdsdType = "minjuyhgdsdsdType"
	
	case reviewRequestCounter = "reviewRequestCounter"
	
	var description: String {
		return rawValue
	}
	
}

class PJHHJJJSDrences {
	
	private static let appSpecific = KeyValueStore(userDefaults: UserDefaults.standard)
	private init() {}
	
	static var reviewRequestThreshold: Int {
		return 3
	}
	static var reviewRequestCounter: Int {
		get {
			return appSpecific.integer(forKey: MKUKsdafsafrenceKeys.reviewRequestCounter)
		}
		set {
			appSpecific.set(newValue, forKey: MKUKsdafsafrenceKeys.reviewRequestCounter)
			appSpecific.synchronize()
		}
	}
	
	static var authorized: Bool {
		get {
			return appSpecific.bool(forKey: MKUKsdafsafrenceKeys.authorized)
		}
		set {
			appSpecific.set(newValue, forKey: MKUKsdafsafrenceKeys.authorized)
			appSpecific.synchronize()
		}
	}
	
	static var authVersion: Int {
		get {
			return appSpecific.integer(forKey: MKUKsdafsafrenceKeys.authVersion)
		}
		set {
			appSpecific.set(newValue, forKey: MKUKsdafsafrenceKeys.authVersion)
			appSpecific.synchronize()
		}
	}
	
	static var minjuyhgdsdsdType: Activity {
		get {
			let def = Activity.running
			guard let rawAct = UInt(exactly: appSpecific.integer(forKey: MKUKsdafsafrenceKeys.minjuyhgdsdsdType)),
				let act = HKWorkoutActivityType(rawValue: rawAct) else {
				return def
			}
			
			return Activity.sdfasHesadfalthsdfsadfKitEquivalent(act) ?? def
		}
		set {
			appSpecific.set(newValue.asdfashealthKsadfsadfitsadfEquivalent.rawValue, forKey: MKUKsdafsafrenceKeys.minjuyhgdsdsdType)
			appSpecific.synchronize()
		}
	}
	
}
