//
//  GameScene.swift
//  Vector Adder
//
//  Created by Jackson Kearl on 1/30/15.
//  Copyright (c) 2015 Jackson Kearl. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let squareFrame = CGRectMake(-self.frame.width/2.0, -self.frame.width/2.0, self.frame.width, self.frame.width)
        let mainNode = SKShapeNode(rect: squareFrame)
        mainNode.fillColor = .blueColor()
        mainNode.strokeColor = .clearColor()
        mainNode.position = CGPointMake(self.frame.width/2 , self.frame.height-self.frame.width/2)
        self.addChild(mainNode)
        
        let initialArrow = VAArrow()
        initialArrow.anchorPoint = CGPointMake(4/33.0, 12/24.0)

        mainNode.addChild(initialArrow)
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

    }
}
