//
//  GameScene.swift
//  Vector Adder
//
//  Created by Jackson Kearl on 1/30/15.
//  Copyright (c) 2015 Jackson Kearl. All rights reserved.
//

import SpriteKit

func + (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVectorMake(lhs.dx+rhs.dx, lhs.dy+rhs.dy)
}

func += (inout lhs: CGVector, rhs:CGVector) {
    lhs = lhs + rhs
}

class GameScene: SKScene {
    var currentVectors = [VAArrow]()
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
    var netForceArrow = VAArrow(color: UIColor.redColor(), magnitude: 2, scale: 1)
    
    override func didMoveToView(view: SKView) {
        let squareFrame = CGRectMake(-self.frame.width/2.0, -self.frame.width/2.0, self.frame.width, self.frame.width)
        mainNode = SKShapeNode(rect: squareFrame)
        mainNode!.fillColor = .blueColor()
        mainNode!.strokeColor = .clearColor()
        mainNode!.position = CGPointMake(self.frame.width/2 , self.frame.height-self.frame.width/2)
        mainNode!.name = "Simulation Background"
        self.addChild(mainNode!)
        
        let initialArrow = VAArrow(color: UIColor.blackColor(), magnitude: 2, scale: scale)
        currentVectors.append(initialArrow)
        netForceArrow.hidden = true
        
        let centerDot = SKShapeNode(circleOfRadius: 3)
        centerDot.fillColor = UIColor.blackColor()
        centerDot.strokeColor = UIColor.blackColor()
       
        mainNode!.addChild(netForceArrow)
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
        
        
        let addForceButton = FBButtonNode(text: "Add Force", identifier: "Add Force", size: 24)
        addForceButton.position = CGPointMake(self.size.width/2, 70)
        addChild(addForceButton)
        
        let remForceButton = FBButtonNode(text: "Remove Force", identifier: "Remove Force", size: 24)
        remForceButton.position = CGPointMake(self.size.width/2, 140)
        addChild(remForceButton)
        
        let showNetButton = FBBooleanButton(text: "Show Net Force", identifier: "Net Force", size: 24)
        showNetButton.position = CGPointMake(self.size.width/2, 105)
        addChild(showNetButton)
        
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let childOfSceneNodeTouched = nodeAtPoint(touch.locationInNode(self))
        
        if childOfSceneNodeTouched.parent is VAArrow {
            validTouchActive = true
            nodeToMove = (childOfSceneNodeTouched.parent! as VAArrow)
        }
        
        if (childOfSceneNodeTouched.parent?.parent is FBBooleanButton) {
            (childOfSceneNodeTouched.parent!.parent as FBBooleanButton).switchEnabled();
        } else if (childOfSceneNodeTouched.parent?.parent is FBButtonNode) {
            (childOfSceneNodeTouched.parent!.parent as FBButtonNode).setTouched(true);
        }
    }
    
    func setUpNetForce() {
        var netVector = CGVectorMake(0, 0)
        for child in currentVectors {
            netVector += child.value
        }
        netForceArrow.setEndPosition(CGPointMake(netVector.dx*32*scale, netVector.dy*32*scale), scale: scale)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if (validTouchActive && (nodeToMove !== netForceArrow)) {
            nodeToMove!.setEndPosition(touches.anyObject()!.locationInNode(mainNode), scale: scale)
            setUpNetForce()
        }
        
        let touch = touches.anyObject() as UITouch
        
        let childOfMainSceneTouched = nodeAtPoint(touch.previousLocationInNode(self))
        
        
        if (childOfMainSceneTouched !== nodeAtPoint(touch.locationInNode(self))) {
            if (childOfMainSceneTouched.parent?.parent is FBBooleanButton) {
                (childOfMainSceneTouched.parent!.parent as FBBooleanButton).switchEnabled();
            } else if (childOfMainSceneTouched.parent?.parent is FBButtonNode) {
                (childOfMainSceneTouched.parent!.parent as FBButtonNode).setTouched(false);
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        validTouchActive = false

        let nodeTouched = self.nodeAtPoint((touches.anyObject() as UITouch).locationInNode(self))
        
        if (nodeTouched.parent?.parent is FBBooleanButton) {
        } else if (nodeTouched.parent?.parent is FBButtonNode) {
            (nodeTouched.parent!.parent as FBButtonNode).setTouched(false);
        }
        


        
        if let name = nodeTouched.name? {
            switch (name) {
            case "Arrow Handle":
                nodeToMove = (nodeTouched.parent as VAArrow)
                
            case "Zoom In" :
                scale *= 2
                
            case "Zoom Out" :
                scale /= 2
                
            case "Add Force" :
                let newVector = VAArrow(color: UIColor.blackColor(), magnitude: 2, scale: scale)
                currentVectors.append(newVector)
                mainNode?.addChild(newVector)
                setUpNetForce()
                
            case "Net Force" :
                netForceArrow.hidden = !netForceArrow.hidden
                setUpNetForce()
                
            case "Remove Force" :
                if (currentVectors.count != 0) {
                    currentVectors.removeLast().removeFromParent()
                }
                setUpNetForce()
            default:
                break
            }
        }
        setUpNetForce()
    }
    

}
