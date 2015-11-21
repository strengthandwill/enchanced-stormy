//
//  DetailBackgroundView.swift
//  Stormy
//
//  Created by Poh Kah Kong on 12/9/15.
//  Copyright (c) 2015 Algomized. All rights reserved.
//

import UIKit

class DetailBackgroundView: UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let circleOrigin = CGPointMake(0, 0.80 * self.frame.height)
        let circleSize = CGSizeMake(self.frame.width, 0.65 * self.frame.height)

        drawBackground(context, circleOrigin: circleOrigin, circleSize: circleSize)
        drawSun(context, circleOrigin: circleOrigin, circleSize: circleSize)
        let position = CGFloat(NSDate().totalSeconds()) / 86400.0
        drawLine(context, circleOrigin: circleOrigin, circleSize: circleSize, position: position)
    }
    
    func drawBackground(context: CGContext?, circleOrigin: CGPoint, circleSize: CGSize) {
        //// Color Declarations
        let lightPurple: UIColor = UIColor(red:0, green:0.58, blue:1, alpha:1)
        let darkPurple: UIColor = UIColor(red:0.51, green:0.81, blue:0.93, alpha:1)
        
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
    
    func drawSun(context: CGContext?, circleOrigin: CGPoint, circleSize: CGSize) {
        let pathStrokeColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.390)
        let pathFillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.100)
        
        //// Sun Drawing
        let sunPath = UIBezierPath(ovalInRect: CGRectMake(circleOrigin.x, circleOrigin.y, circleSize.width, circleSize.height))
        pathFillColor.setFill()
        sunPath.fill()
        pathStrokeColor.setStroke()
        sunPath.lineWidth = 1
        
        CGContextSaveGState(context)
        CGContextSetLineDash(context, 0, [2, 2], 2)
        sunPath.stroke()
    }
    
    func drawLine(context: CGContext?, circleOrigin: CGPoint, circleSize: CGSize, position: CGFloat) {
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = 2
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(CGPoint(
            x: circleOrigin.x + position * circleSize.width,
            y: circleOrigin.y))
        
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(CGPoint(
            x: circleOrigin.x + position * circleSize.width,
            y: circleOrigin.y + circleSize.height))
        
        //set the stroke color
        UIColor.whiteColor().setStroke()
        CGContextSetLineDash(context, 0, nil, 0)
        
        //draw the stroke
        plusPath.stroke()
        CGContextRestoreGState(context)
    }
}
