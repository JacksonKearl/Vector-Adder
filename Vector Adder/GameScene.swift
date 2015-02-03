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
    var componentsVisible: Bool = false {
        didSet {
            for child in mainNode!.children {
                if child is VAArrow && (child !== netForceArrow) {
                    (child as VAArrow).components.hidden = !componentsVisible
                }
            }
            netForceArrow.components.hidden = !componentsVisible || netForceArrow.hidden
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
        
        let buttonBackdrop = SKShapeNode(rect: CGRectMake(0, 0, self.size.width, self.size.height-self.size.width))
        buttonBackdrop.strokeColor = UIColor.clearColor()
        buttonBackdrop.fillColor = UIColor.blackColor()
        buttonBackdrop.zPosition = 1
        addChild(buttonBackdrop)
        
        
        let initialArrow = VAArrow(color: UIColor.blackColor(), magnitude: 2, scale: scale)
        currentVectors.append(initialArrow)
        netForceArrow.hidden = true
        
        let centerDot = SKShapeNode(circleOfRadius: 3)
        centerDot.fillColor = UIColor.blackColor()
        centerDot.strokeColor = UIColor.blackColor()
       
        mainNode!.addChild(netForceArrow)
        mainNode!.addChild(netForceArrow.components)
        mainNode!.addChild(initialArrow)
        mainNode!.addChild(initialArrow.components)
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
        let minusLabel = SKLabelNode(text: "-")
        minusLabel.fontSize = 68
        minusLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        zoomOut.addChild(minusLabel)
        zoomOut.position = CGPointMake(-(self.size.width/2-15), -(self.size.width/2-15))
        mainNode!.addChild(zoomOut)
        zoomOut.name = "Zoom Out"
        minusLabel.name = "Zoom Out"
        
        let heightOfAd = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? CGFloat(66.0) : CGFloat( 50.0)
        let distBetweenSimAndAdd = self.size.height - self.size.width - heightOfAd  - 5
        
        
        let addForceButton = FBButtonNode(text: "Create Vector", identifier: "Add Force", size: 15)
        addForceButton.position = CGPointMake(self.size.width/4, heightOfAd + distBetweenSimAndAdd/3 + 20)
        buttonBackdrop.addChild(addForceButton)
        
        let remForceButton = FBButtonNode(text: "Remove Vector", identifier: "Remove Force", size: 15)
        remForceButton.position = CGPointMake(3*self.size.width/4, heightOfAd + distBetweenSimAndAdd/3 + 20)
        buttonBackdrop.addChild(remForceButton)
        
        let showNetButton = FBBooleanButton(text: "Show Vector Sum", identifier: "Net Force", size: 15)
        showNetButton.position = CGPointMake(self.size.width/2, heightOfAd + (2 * distBetweenSimAndAdd)/3 + 20 )
        buttonBackdrop.addChild(showNetButton)
        
        let showCompButton = FBBooleanButton(text: "Show Vector Components", identifier: "Show Components", size: 15)
        showCompButton.position = CGPointMake(self.size.width/2, heightOfAd + 20)
        buttonBackdrop.addChild(showCompButton)
        
        
        
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
                mainNode!.addChild(newVector.components)
                newVector.components.hidden = !componentsVisible
                setUpNetForce()
                
            case "Net Force" :
                netForceArrow.hidden = !netForceArrow.hidden
                
                if !netForceArrow.hidden {
                    netForceArrow.components.hidden = !componentsVisible
                } else {
                    netForceArrow.components.hidden = true
                }
                
                setUpNetForce()
                
            case "Remove Force" :
                if (currentVectors.count != 0) {
                    currentVectors.last?.components.removeFromParent()
                    currentVectors.removeLast().removeFromParent()
                }
                setUpNetForce()
                
            case "Show Components" :
                componentsVisible = !componentsVisible

                
            default:
                break
            }
        }
        setUpNetForce()
    }
    

}
