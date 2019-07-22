//
//  GraadasddsadasdadsientButton.swift
//  InfinityTracker
//
//  Created by Alex on 31/08/2017.
//  Copyright © 2017 AleksZilla. All rights reserved.
//

import UIKit

@IBDesignable class GraadasddsadasdadsientButton : UIButton {
    
    // MARK: Properties
    
    @IBInspectable var asddsastarasdadstColor: UIColor = Londpradarance.lokndinedsdDark {
        didSet{
            setaddsaupadasdView()
        }
    }
    
    @IBInspectable var sadendsadsaColor: UIColor = Londpradarance.lineokdeLight {
        didSet{
            setaddsaupadasdView()
        }
    }
    
    var mikjkjhyjjshjjjdsdtLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // MARK: LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setaddsaupadasdView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setaddsaupadasdView()
    }
    
    // MARK: Setup View
    
    private func setaddsaupadasdView(){
        let colors = [asddsastarasdadstColor.cgColor, sadendsadsaColor.cgColor]
        mikjkjhyjjshjjjdsdtLayer.colors = colors
        mikjkjhyjjshjjjdsdtLayer.startPoint = CGPoint(x: 0, y: 0)
        mikjkjhyjjshjjjdsdtLayer.endPoint = CGPoint(x: 1, y: 0)
        self.setNeedsDisplay()
    }
    
}
