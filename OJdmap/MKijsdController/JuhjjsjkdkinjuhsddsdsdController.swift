//
//  JuhjjsjkdkinjuhsddsdsdController.swift
//  InfinityTracker
//
//  Created by Marco Boschi on 02/05/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//

import UIKit
import MBLibrary
import HealthKit

class JuhjjsjkdkinjuhsddsdsdController: UIViewController {
	
	@IBOutlet weak var cnijhuhhsdsddtWeight: UILabel!
	@IBOutlet weak var buyhngtdseWeight: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

		updateWeight()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func updateWeight() {
		MKjjjkskdsddssdKitManager.getasdfasdfRealsadfasdWeight { OFE_w in
			DispatchQueue.main.async {
				self.cnijhuhhsdsddtWeight.text = Londpradarance.format(weight: OFE_w?.doubleValue(for: .gramUnit(with: .kilo)))
			}
		}
	}

	@IBAction func save(_ sender: AnyObject) {
		guard let OFE_w = (buyhngtdseWeight.text ?? "").toDouble(), OFE_w > 0 else {
			buyhngtdseWeight.shake()
			buyhngtdseWeight.becomeFirstResponder()
			return
		}
		
		let xqsdusdadasntity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: OFE_w)
		let minjjdnow = Date()
		let kimnjhdweight = HKQuantitySample(type: MKjjjkskdsddssdKitManager.asfadsfsadfstType, quantity: xqsdusdadasntity, start: minjjdnow, end: minjjdnow)
		MKjjjkskdsddssdKitManager.healthStore.save(kimnjhdweight) { res, _ in
			DispatchQueue.main.async {
				if res {
					self.buyhngtdseWeight.text = ""
					self.buyhngtdseWeight.resignFirstResponder()
					self.updateWeight()
				} else {
					let mikjkalddert = UIAlertController(simpleAlert: NSLocalizedString("ERROR", comment: "Error"), message: NSLocalizedString("WEIGHT_SAVE_ERROR", comment: "Cannot save"))
					self.present(mikjkalddert, animated: true)
				}
			}
		}
	}

}
