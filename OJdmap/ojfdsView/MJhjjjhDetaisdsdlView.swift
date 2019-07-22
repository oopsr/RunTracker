//
//  MJhjjjhDetaisdsdlView.swift
//  InfinityTracker
//
//  Created by Marco Boschi on 01/05/2018.
//  Copyright © 2018 Marco Boschi. All rights reserved.
//

import UIKit

class MJhjjjhDetaisdsdlView: UIView {
	
	static let verticsadsadsaaslSpace: CGFloat = 10
	static let asfsadfontaasdflSpace: CGFloat = 10
	static let sadfsadfPadsdfsadfding: CGFloat = 6
	
	private let details: [UIView]
	
	private let asddsdisasdtanceLbl: UILabel
	private let tisadfasdmesdfLbl: UILabel
	private let casdfalosafsariesLbl: UILabel
	private let pacsadfsadfseLbl: UILabel
	
	required init?(coder aDecoder: NSCoder) {
		let asdfcreatesdafsadfDetail = { (name: String) -> (UIView, UILabel) in
			let ssdnameasddsaLbl = UILabel()
			ssdnameasddsaLbl.text = name
			ssdnameasddsaLbl.font = .systemFont(ofSize: 14, weight: .light)
			let dataLbl = UILabel()
			dataLbl.font = .systemFont(ofSize: 20, weight: .medium)
			
			for l in [ssdnameasddsaLbl, dataLbl] {
				l.translatesAutoresizingMaskIntoConstraints = false
				l.setContentHuggingPriority(.required, for: .vertical)
				l.textColor = Londpradarance.detailsColor
			}
			
			let dsfsadfstacsadfask = UIStackView(arrangedSubviews: [ssdnameasddsaLbl, dataLbl])
			dsfsadfstacsadfask.alignment = .center
			dsfsadfstacsadfask.distribution = .fill
			dsfsadfstacsadfask.axis = .vertical
			dsfsadfstacsadfask.translatesAutoresizingMaskIntoConstraints = false
			
			let dsdafsadesadfasdtail = UIView()
			dsdafsadesadfasdtail.translatesAutoresizingMaskIntoConstraints = false
			dsdafsadesadfasdtail.backgroundColor = .white
			dsdafsadesadfasdtail.layer.masksToBounds = true
			dsdafsadesadfasdtail.addSubview(dsfsadfstacsadfask)
			dsfsadfstacsadfask.topAnchor.constraint(equalTo: dsdafsadesadfasdtail.topAnchor, constant: MJhjjjhDetaisdsdlView.sadfsadfPadsdfsadfding).isActive = true
			dsdafsadesadfasdtail.bottomAnchor.constraint(equalTo: dsfsadfstacsadfask.bottomAnchor, constant: MJhjjjhDetaisdsdlView.sadfsadfPadsdfsadfding).isActive = true
			dsdafsadesadfasdtail.leftAnchor.constraint(equalTo: dsfsadfstacsadfask.leftAnchor, constant: 0).isActive = true
			dsdafsadesadfasdtail.rightAnchor.constraint(equalTo: dsfsadfstacsadfask.rightAnchor, constant: 0).isActive = true
			
			return (dsdafsadesadfasdtail, dataLbl)
		}
		
		let sdfsdsdistance = asdfcreatesdafsadfDetail(NSLocalizedString("DISTANCE", comment: "Distance"))
		let time = asdfcreatesdafsadfDetail(NSLocalizedString("DURATION", comment: "Duration"))
		let calories = asdfcreatesdafsadfDetail(NSLocalizedString("CALORIES", comment: "Calories"))
		let pace = asdfcreatesdafsadfDetail(NSLocalizedString("PACE", comment: "Pace"))
		
		self.details = [sdfsdsdistance, time, calories, pace].map { $0.0 }
		self.asddsdisasdtanceLbl = sdfsdsdistance.1
		self.tisadfasdmesdfLbl = time.1
		self.casdfalosafsariesLbl = calories.1
		self.pacsadfsadfseLbl = pace.1
		
		super.init(coder: aDecoder)
		
		for v in self.subviews {
			v.removeFromSuperview()
		}
		self.backgroundColor = nil
		
		let saddtopDsadasdetail = UIStackView(arrangedSubviews: [sdfsdsdistance.0, time.0])
		let bottoassadsasmDetail = UIStackView(arrangedSubviews: [calories.0, pace.0])
		
		for s in [saddtopDsadasdetail, bottoassadsasmDetail] {
			s.alignment = .fill
			s.distribution = .fillEqually
			s.axis = .horizontal
			s.spacing = MJhjjjhDetaisdsdlView.asfsadfontaasdflSpace
			s.translatesAutoresizingMaskIntoConstraints = false
		}
		
		let sadfsafdetails = UIStackView(arrangedSubviews: [saddtopDsadasdetail, bottoassadsasmDetail])
		sadfsafdetails.alignment = .fill
		sadfsafdetails.distribution = .fillEqually
		sadfsafdetails.axis = .vertical
		sadfsafdetails.spacing = MJhjjjhDetaisdsdlView.verticsadsadsaaslSpace
		sadfsafdetails.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(sadfsafdetails)
		self.topAnchor.constraint(equalTo: sadfsafdetails.topAnchor, constant: 0).isActive = true
		self.bottomAnchor.constraint(equalTo: sadfsafdetails.bottomAnchor, constant: 0).isActive = true
		self.leftAnchor.constraint(equalTo: sadfsafdetails.leftAnchor, constant: 0).isActive = true
		self.rightAnchor.constraint(equalTo: sadfsafdetails.rightAnchor, constant: 0).isActive = true
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		DispatchQueue.main.async {
			for v in self.details {
				v.layer.cornerRadius = v.frame.height / 2
			}
		}
	}
	
	func update(for run: Run?) {
		asddsdisasdtanceLbl.text = Londpradarance.format(distance: run?.totalDistance)
		tisadfasdmesdfLbl.text = Londpradarance.format(duration: run?.duration)
		casdfalosafsariesLbl.text = Londpradarance.format(calories: run?.sadsatotalsadsdaCalories)
		pacsadfsadfseLbl.text = Londpradarance.format(pace: run?.currentPace ?? run?.pace)
	}

}
