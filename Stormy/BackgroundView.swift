//
//  BackgroundView.swift
//  Stormy
//
//  Created by Poh Kah Kong on 11/9/15.
//  Copyright (c) 2015 Algomized. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Background View
        
        //// Color Declarations
        let lightPurple: UIColor = UIColor(red:0, green:0.58, blue:1, alpha:1)
        let darkPurple: UIColor = UIColor(red:0.51, green:0.81, blue:0.93, alpha:1)
        
        let context = UIGraphicsGetCurrentContext()
        
        //// Gradient Declarations
        let purpleGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [lightPurple.CGColor, darkPurple.CGColor], [0, 1])
        
        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, self.frame.height))
        CGContextSaveGState(context)
        backgroundPath.addClip()
        CGContextDrawLinearGradient(context, purpleGradient,
            CGPointMake(160, 0),
            CGPointMake(160, 568),
            [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        CGContextRestoreGState(context)
    }
}
