//
//  VAArrow.swift
//  Vector Adder
//
//  Created by Jackson Kearl on 1/30/15.
//  Copyright (c) 2015 Jackson Kearl. All rights reserved.
//

import UIKit
import SpriteKit

class VAArrow: SKSpriteNode {
    var value:CGVector = CGVectorMake(2, 0)
    private var magnitude:CGFloat = 0
    private var magnitudeLabel = SKLabelNode(fontNamed: "GillSans-Bold")
    private var touchArea = SKShapeNode(circleOfRadius: 15)
    private var previousScale:CGFloat = 1.0
    private var endPoint = CGPointMake(66, 0)
    
    private let randXComp = CGFloat(arc4random()%50 + 25)/100.0
    private let randYComp = CGFloat(arc4random()%50 + 25)/100.0
    
    
    var components = SKNode()
    
    
    init(color: UIColor, magnitude mag: CGFloat, scale: CGFloat) {
        super.init(texture: SKTexture(imageNamed: "Arrow"), color: color, size: CGSizeMake(33,24))
        self.colorBlendFactor = 1
        self.centerRect = CGRectMake(5/33.0, 12/24.0, 2/33.0, 3/24.0)
        self.magnitude = mag
        self.anchorPoint = CGPointMake(0/33.0, 12/24.0)
        
        
        touchArea.position = CGPointMake(33-10/(magnitude * scale), 0)
        touchArea.name = "Arrow Handle"
        touchArea.xScale = 1/(magnitude*scale);
        touchArea.lineWidth = 0
        
        magnitudeLabel.text = NSString(format: "%.2f", Double(magnitude))
        magnitudeLabel.position = CGPointMake(2*(33-10)/3, 0)
        magnitudeLabel.xScale = 1/(magnitude*scale)
        magnitudeLabel.fontSize = 10
        magnitudeLabel.zPosition = 2
        addChild(magnitudeLabel)
        
        self.addChild(touchArea)
        
        self.xScale = magnitude*scale;
        previousScale = scale
        
        components.name = "Vector Components"
        components.hidden = true
        
    }
    
    func setEndPosition(e:CGPoint, scale:CGFloat){
        
        endPoint = e
        previousScale = scale
        setLength(magnitude * scale)
        
        var angle:CGFloat = atan(e.y/e.x)
        angle = (e.x < 0) ? angle+3.141592 : angle
        self.zRotation = angle
        let distToEnd = sqrt(e.x*e.x + e.y*e.y)
        magnitude = distToEnd/(scale*32)
        
        value = CGVectorMake(cos(angle)*magnitude, sin(angle)*magnitude)
        
        
        magnitudeLabel.text = NSString(format: "%.2f", Double(magnitude))
        magnitudeLabel.zRotation = (e.x < 0) ? 3.141592 : 0
        
        components.removeAllChildren()
        
        if (!(abs(e.x) < 1 || abs(e.y) < 1)) {
            if (abs(e.y) < abs(e.x)) {
                let xComponent = SKShapeNode(rect: CGRectMake(0, 0, e.x, 0))
                let yComponent = SKShapeNode(rect: CGRectMake(e.x, 0, 0, e.y))
                components.addChild(xComponent)
                components.addChild(yComponent)
            } else {
                let xComponent = SKShapeNode(rect: CGRectMake(0, e.y, e.x, 0))
                let yComponent = SKShapeNode(rect: CGRectMake(0, 0, 0, e.y))
                components.addChild(xComponent)
                components.addChild(yComponent)
            }
            
            let xLabel = SKLabelNode(text:  NSString(format: "%.2f", Double(value.dx)))
            xLabel.fontName = "GillSans-Bold"
            xLabel.fontSize = 10
            
            let yLabel = SKLabelNode(text:  NSString(format: "%.2f", Double(value.dy)))
            yLabel.fontName = "GillSans-Bold"
            yLabel.fontSize = 10
            
            let quarterCW  = -CGFloat(M_PI_2)
            let quarterCCW = +CGFloat(M_PI_2)
            
            switch abs(e.y) < abs(e.x) {
                
            case (false) : //y is greater magnitude than x, y negative
                yLabel.zRotation = (e.x > 0) ? quarterCW : quarterCCW
                yLabel.position = CGPointMake(0, e.y * randYComp)
                
                xLabel.position = CGPointMake(e.x * randXComp, e.y)
                
            case (true) : //y is lessser magnitude than x, x negative
                yLabel.zRotation = (e.x < 0) ? quarterCCW : quarterCW
                yLabel.position = CGPointMake(e.x, e.y * randYComp)
                
                xLabel.position = CGPointMake(e.x * randXComp, (e.y) > 0 ? 0 : -10)
                
            default :
                break
                
            }
            
            components.addChild(xLabel)
            components.addChild(yLabel)
            
            let arcPath = CGPathCreateMutable()
            var startAngle:CGFloat
            var isCW: Bool
            
            let dAngle = Double(angle)<0 ? Double(angle)+2*M_PI : Double(angle)
            if (dAngle < M_PI_4) {
                startAngle = 0
                isCW = false
            } else if (dAngle < 2*M_PI_4) {
                startAngle = CGFloat(M_PI_2)
                isCW = true
            } else if dAngle < 3*M_PI_4 {
                startAngle = CGFloat(M_PI_2)
                isCW = false
                
            } else if dAngle < 4*M_PI_4 {
                startAngle = CGFloat(M_PI)
                isCW = true
                
            } else if dAngle < 5*M_PI_4 {
                startAngle = CGFloat(M_PI)
                isCW = false
                
            } else if dAngle < 6*M_PI_4 {
                startAngle = CGFloat(3*M_PI_2)
                isCW = true
                
            } else if dAngle < 7*M_PI_4 {
                startAngle = CGFloat(3*M_PI_2)
                isCW = false
                
            } else {
                startAngle = 0
                isCW = true
                
            }
            
            var labelOfAngle = abs(Double(startAngle) - Double(dAngle)) * 180/M_PI
            labelOfAngle = (labelOfAngle < 46) ? labelOfAngle : 360 - labelOfAngle
            assert(labelOfAngle <= 45, "Angle out of RANGE!?!?!!?!")
            
            var angleOfAngleLabel = Double(startAngle) + ((isCW) ? -labelOfAngle * M_PI/360 : +labelOfAngle * M_PI/360)
            
            let xComp = CGFloat(cos(angleOfAngleLabel))
            let yComp = CGFloat(sin(angleOfAngleLabel))
            
            let angleLabel = SKLabelNode(fontNamed: "GillSans-Bold")
            angleLabel.text = NSString(format: "%.0fº", labelOfAngle)
            angleLabel.fontSize = 10
            angleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            angleLabel.position = CGPointMake(distToEnd/2.7 * xComp, distToEnd/2.7 * yComp)
            
            CGPathAddArc(arcPath, nil, 0, 0, distToEnd/3, startAngle, angle, isCW)
            
            let arc = SKShapeNode(path: arcPath)
            arc.addChild(angleLabel)
            
            components.addChild(arc)
            
        }
        
    }
    
    func reScale(scale: CGFloat) {
        let newEndPoint = CGPointMake(endPoint.x*(scale/previousScale), endPoint.y*(scale/previousScale))
        setEndPosition(newEndPoint, scale: scale)
    }
    
    func setLength (length: CGFloat) {
        self.xScale = length
        magnitudeLabel.xScale = 1/length
        touchArea.xScale = 1/length
        
        touchArea.position = CGPointMake(33-10/length, 0)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
