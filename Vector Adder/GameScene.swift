//
//  GameScene.swift
//  Vector Adder
//
//  Created by Jackson Kearl on 1/30/15.
//  Copyright (c) 2015 Jackson Kearl. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var validTouchActive = false
    var nodeToMove:VAArrow?
    var scale:CGFloat = 1.0 {
        didSet {
            for child in mainNode!.children {
                if child is VAArrow {
                    (child as VAArrow).reScale(scale)
                }
            }
        }
    }
    var mainNode:SKShapeNode?
    
    override func didMoveToView(view: SKView) {
        let squareFrame = CGRectMake(-self.frame.width/2.0, -self.frame.width/2.0, self.frame.width, self.frame.width)
        mainNode = SKShapeNode(rect: squareFrame)
        mainNode!.fillColor = .blueColor()
        mainNode!.strokeColor = .clearColor()
        mainNode!.position = CGPointMake(self.frame.width/2 , self.frame.height-self.frame.width/2)
        mainNode!.name = "Simulation Background"
        self.addChild(mainNode!)
        
        let initialArrow = VAArrow(color: UIColor.blackColor(), magnitude: 2, scale: scale)
        
        let centerDot = SKShapeNode(circleOfRadius: 3)
        centerDot.fillColor = UIColor.blackColor()
        centerDot.strokeColor = UIColor.blackColor()
        
        mainNode!.addChild(initialArrow)
        mainNode!.addChild(centerDot)
        
        let zoomIn = SKShapeNode(circleOfRadius: 10)
        let plusLabel = SKLabelNode(text: "+")
        plusLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        plusLabel.name = "Zoom In"
        zoomIn.addChild(plusLabel)
        zoomIn.position = CGPointMake(self.size.width/2-15, -(self.size.width/2-15))
        mainNode!.addChild(zoomIn)
        zoomIn.name = "Zoom In"
        
        let zoomOut = SKShapeNode(circleOfRadius: 10)
        let minusLabel = SKLabelNode(text: "⎯") //This looks like a hyphen. It's not.
        minusLabel.fontSize = 12
        minusLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        zoomOut.addChild(minusLabel)
        zoomOut.position = CGPointMake(-(self.size.width/2-15), -(self.size.width/2-15))
        mainNode!.addChild(zoomOut)
        zoomOut.name = "Zoom Out"
        minusLabel.name = "Zoom Out"
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let nodeTouched = self.nodeAtPoint((touches.anyObject() as UITouch).locationInNode(self))
        
        if let name = nodeTouched.name? {
            switch (name) {
            case "Arrow Handle":
                validTouchActive = true
                nodeToMove = (nodeTouched.parent as VAArrow)
                
            case "Zoom In" :
                scale *= 2
                
            case "Zoom Out" :
                scale /= 2
            default:
                println(nodeTouched)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if validTouchActive {
            nodeToMove!.setEndPosition(touches.anyObject()!.locationInNode(mainNode), scale: scale)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        validTouchActive = false
    }
}
