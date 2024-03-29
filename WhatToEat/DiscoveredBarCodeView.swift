//
// DiscoveredBarCodeView.swift
// BarcodeInventory
//
// Created by Shrikar Archak on 1/22/15.
// Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

import UIKit

class DiscoveredBarCodeView: UIView {
    
    var borderLayer : CAShapeLayer?
    var corners : [CGPoint]?
    var mLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.setMyView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func drawBorder(points : [CGPoint]) {
        self.corners = points
        let path = UIBezierPath()
        
        print(points)
        path.moveToPoint(points.first!)
        for (var i = 1; i < points.count; i++) {
            path.addLineToPoint(points[i])
        }
        path.addLineToPoint(points.first!)
        borderLayer?.path = path.CGPath
    }
    
}