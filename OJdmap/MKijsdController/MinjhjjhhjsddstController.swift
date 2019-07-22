//
//  MinjhjjhhjsddstController.swift
//  InfinityTracker
//
//  Created by Marco Boschi on 08/08/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//

import UIKit
import MBLibrary

class MinjhjjhhjsddstController: UITableViewController {
	
	private var mkijhghjjnhghjjInfo: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        mkijhghjjnhghjjInfo = NSLocalizedString("REPORT_TEXT", comment: "Report problem") + "\n\nInfinityTracker \(Bundle.main.versionDescription)\n© 2017-2018 Marco Boschi, Alexandre Linares"
		
		Londpradarance.asdfasdfasdvgwqewqeweewdNavigationBar(navigationController)
    }
    
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return mkijhghjjnhghjjInfo
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			UIApplication.shared.open(URL(string: "https://github.com/piscoTech/InfinityTracker")!)
		default:
			break
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
    // MARK: - Navigation

	@IBAction func kokhhhjsddone(_ sender: AnyObject) {
		dismiss(animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let id = segue.identifier else {
			return
		}
		
		switch id {
		case "contact":
            _ = "ddd"
//            dest.appName = "InfinityTracker"
		default:
			break
		}
	}

}
