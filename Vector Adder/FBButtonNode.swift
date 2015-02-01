//
//  FBButtonNode.swift
//  FreeBody
//
//  Created by Jackson Kearl on 12/30/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import SpriteKit

class FBButtonNode: SKSpriteNode {
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }

    var buttonText:SKLabelNode?
    var buttonBackground: SKShapeNode?
    var isButton:Bool?

    init(text:String, identifier:String?, size:CGFloat) {
        super.init()
        isButton = (identifier != nil)

        buttonText = SKLabelNode(fontNamed: "GillSans-Bold")
        buttonText!.text = text
        buttonText!.fontColor = UIColor.whiteColor()
        buttonText!.fontSize = size
        buttonText!.verticalAlignmentMode = .Center

        let buttonBoundRect = CGSizeMake(max(buttonText!.frame.width+10, 30), max(buttonText!.fontSize, 30))
        buttonBackground = SKShapeNode(rectOfSize: buttonBoundRect)
        buttonBackground!.fillColor = UIColor.blueColor()
        buttonBackground!.strokeColor = UIColor.lightGrayColor()
        buttonBackground!.lineWidth = (identifier==nil) ? 0 : 1

        let buttonResponder = SKSpriteNode(texture: nil, color: nil, size: buttonBackground!.frame.size)
        buttonResponder.name = identifier

        buttonBackground!.addChild(buttonText!)
        buttonBackground!.addChild(buttonResponder)

        self.addChild(buttonBackground!)
        self.size = buttonBackground!.frame.size

    }
    

    func setTouched(touch:Bool){
        if touch && isButton! {
            buttonText!.fontColor = UIColor.lightGrayColor()
            buttonBackground?.strokeColor = UIColor.lightGrayColor()
        } else {
            buttonText!.fontColor = UIColor.whiteColor()
            buttonBackground?.strokeColor = UIColor.whiteColor()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
