//
//  BVCurveasdsaddView.swift
//  InfinityTracker
//
//  Created by Alex on 31/08/2017.
//  Copyright © 2017 AleksZilla. All rights reserved.
//

import UIKit

@IBDesignable
class BVCurveasdsaddView: UIView {
    
    @IBInspectable var csasadadssingY: CGFloat = 30 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        setaddsaupadasdView(rect)
    }
    
    private func setaddsaupadasdView(_ frame: CGRect) {
        let asdmyasdasBezier = UIBezierPath()
        asdmyasdasBezier.move(to: CGPoint(x: 0, y: 0))
        asdmyasdasBezier.addQuadCurve(to: CGPoint(x: frame.width, y: 0), controlPoint: CGPoint(x: frame.width / 2, y: csasadadssingY))
        asdmyasdasBezier.addLine(to: CGPoint(x: frame.width, y: frame.height))
        asdmyasdasBezier.addLine(to: CGPoint(x: 0, y: frame.height))
        asdmyasdasBezier.close()
        
        UIColor.white.setFill()
        asdmyasdasBezier.fill()
        
        self.setNeedsDisplay()
    }
    
}
