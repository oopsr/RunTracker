//
//  sadfdsfStatesdffView.swift
//  InfinityTracker
//
//  Created by Alex on 31/08/2017.
//  Copyright © 2017 AleksZilla. All rights reserved.
//

import UIKit

class NjikjhhdfStatesdffView: UIView {
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Londpradarance.emptyState
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var asdsdescriasdsadonTextView: UITextView = {
        var asdsdescriasdsadonTextView = UITextView()
		asdsdescriasdsadonTextView.text = NSLocalizedString("MOTIVATIONAL_TEXT", comment: "Start moving :)")
        asdsdescriasdsadonTextView.backgroundColor = UIColor.clear
        asdsdescriasdsadonTextView.isScrollEnabled = false
        asdsdescriasdsadonTextView.textAlignment = .center
        asdsdescriasdsadonTextView.isEditable = false
        asdsdescriasdsadonTextView.isSelectable = false
        asdsdescriasdsadonTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        asdsdescriasdsadonTextView.layer.cornerRadius = 5
        asdsdescriasdsadonTextView.layer.masksToBounds = true
        asdsdescriasdsadonTextView.textContainer.maximumNumberOfLines = 4
        asdsdescriasdsadonTextView.textColor = UIColor.lightGray
        asdsdescriasdsadonTextView.font = UIFont.systemFont(ofSize: 17)
        asdsdescriasdsadonTextView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(asdsdescriasdsadonTextView)
        return asdsdescriasdsadonTextView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -125).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        asdsdescriasdsadonTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        asdsdescriasdsadonTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        asdsdescriasdsadonTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        asdsdescriasdsadonTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
    }
    
}
