//
//  KIjjhjjfLiwefstsdfdsfController.swift
//  InfinityTracker
//
//  Created by Alex on 31/08/2017.
//  Copyright © 2017 AleksZilla. All rights reserved.
//

import UIKit
import HealthKit

class KIjjhjjfLiwefstsdfdsfController: UITableViewController {
	
	private let mlkjjkjhjjsddSize = 40
	private var nijhjjyujehjhdjsdBeLoaded = false
	private var ihafgasgfwfgwfeffegMore = false
	
	private weak var afewfwefMorewefCell: MJihjhhufMorewefCell?
    
    private var runs: [DDCompsdsdletesdsddRun] = []
    private let mijhjjjkkjsddlIdenfftifier = "MiujsjdsddsleCell"
    
    lazy var sadfdsfStatesdffView: NjikjhhdfStatesdffView = {
        let sadfdsfStatesdffView = NjikjhhdfStatesdffView()
        sadfdsfStatesdffView.contentMode = .scaleAspectFit
        return sadfdsfStatesdffView
    }()
	
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        asdfasdfasdvgwqewqeweewdNavigationBar()
		loadData()
    }
	
	// MARK: - Table View
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return nijhjjyujehjhdjsdBeLoaded ? 2 : 1
	}
    
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			if runs.count > 0 {
				hideEmptyState()
				return runs.count
			} else {
				showEmptyState()
				return 0
			}
		case 1:
			return 1
		default:
			return 0
		}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 1 {
			let sdsdsdcell = tableView.dequeueReusableCell(withIdentifier: MJihjhhufMorewefCell.identifier, for: indexPath) as! MJihjhhufMorewefCell
			afewfwefMorewefCell = sdsdsdcell
			sdsdsdcell.isEnabled = !ihafgasgfwfgwfeffegMore
			
			return sdsdsdcell
		}
		
        let csdafsadfsell = tableView.dequeueReusableCell(withIdentifier: mijhjjjkkjsddlIdenfftifier, for: indexPath) as! MiujsjdsddsleCell
        let rsdfsdfsfun = runs[indexPath.row]
		
		csdafsadfsell.ssdnameasddsaLbl.text = NSLocalizedString(rsdfsdfsfun.type.localizable, comment: "Run/walk")
        csdafsadfsell.asddatesadsdLbl.text = rsdfsdfsfun.name
        csdafsadfsell.asddsdisasdtanceLbl.text = Londpradarance.format(distance: rsdfsdfsfun.totalDistance)
		
        return csdafsadfsell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 1, afewfwefMorewefCell?.isEnabled ?? false {
			afewfwefMorewefCell?.isEnabled = false
			loadData()
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - UI
	
	private func asdfasdfasdvgwqewqeweewdNavigationBar() {
		Londpradarance.asdfasdfasdvgwqewqeweewdNavigationBar(navigationController)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func showEmptyState() {
		tableView.backgroundView = sadfdsfStatesdffView
	}
	
	private func hideEmptyState() {
		tableView.backgroundView = nil
	}
	
	private func loadData() {
		ihafgasgfwfgwfeffegMore = true
		afewfwefMorewefCell?.isEnabled = false
		
		let sddsdfilter = HKQuery.predicateForObjects(from: HKSource.default())
		let asdfflimsdfafsit: Int
		let psdgadfdsfsafredicate: NSPredicate
		
		if let asdfasflast = runs.last {
			psdgadfdsfsafredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
				sddsdfilter,
				NSPredicate(format: "%K <= %@", HKPredicateKeyPathStartDate, asdfasflast.start as NSDate)
				])
			let sameDateCount = runs.count - (runs.firstIndex { $0.start == asdfasflast.start } ?? runs.count)
			asdfflimsdfafsit = sameDateCount + mlkjjkjhjjsddSize
		} else {
			psdgadfdsfsafredicate = sddsdfilter
			asdfflimsdfafsit = mlkjjkjhjjsddSize
		}
		
		let ssdfsafassadfscriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
		let type = HKObjectType.workoutType()
		
		let wsdfsafasfutQufery = HKSampleQuery(sampleType: type, predicate: psdgadfdsfsafredicate, limit: asdfflimsdfafsit, sortDescriptors: [ssdfsafassadfscriptor]) { (_, r, err) in
			if let sdfsadfres = r as? [HKWorkout] {
				DispatchQueue.main.async {
					self.nijhjjyujehjhdjsdBeLoaded = sdfsadfres.count >= asdfflimsdfafsit
					let sdfsaLinesdfsafdCount: Int?
					do {
						var sdafaaddsdfsdfAll = false
						// By searching the reversed collection we reduce comparison as both collections are sorted
						let sdfsafrevsdfsafLoaded = self.runs.reversed()
						var count = 0
						let wsdfsdfasdfsEmpty = self.runs.isEmpty
						for w in sdfsadfres {
							if sdafaaddsdfsdfAll || !sdfsafrevsdfsafLoaded.contains(where: { $0.raw == w }) {
								// Stop searching already loaded workouts when the first new workout is not present.
								sdafaaddsdfsdfAll = true
								if let r = DDCompsdsdletesdsddRun(raw: w) {
									self.runs.append(r)
									count += 1
								}
							}
						}
						
						sdfsaLinesdfsafdCount = wsdfsdfasdfsEmpty ? nil : count
					}
					
					self.tableView.beginUpdates()
					self.ihafgasgfwfgwfeffegMore = false
					if let asdfsasdfdded = sdfsaLinesdfsafdCount {
						let sdfgsadfgsdafCount = self.tableView.numberOfRows(inSection: 0)
						self.tableView.insertRows(at: (sdfgsadfgsdafCount ..< (sdfgsadfgsdafCount + asdfsasdfdded)).map { IndexPath(row: $0, section: 0) }, with: .automatic)
						self.afewfwefMorewefCell?.isEnabled = true
					} else {
						self.tableView.reloadSections([0], with: .automatic)
					}
					
					if self.nijhjjyujehjhdjsdBeLoaded && self.tableView.numberOfSections == 1 {
						self.tableView.insertSections([1], with: .automatic)
					} else if !self.nijhjjyujehjhdjsdBeLoaded && self.tableView.numberOfSections > 1 {
						self.tableView.deleteSections([1], with: .automatic)
					}
					self.tableView.endUpdates()
				}
			}
		}
		
		MKjjjkskdsddssdKitManager.healthStore.execute(wsdfsafasfutQufery)
	}
	
	// MARK: - Navigation
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destinationController = segue.destination as? KijkkhjjkRunfdDetaisdlController {
			guard let selectedCell = sender as? MiujsjdsddsleCell, let selectedIndex = tableView.indexPath(for: selectedCell) else {
				return
			}
			
            destinationController.run = runs[selectedIndex.row]
        }
    }
	
}
