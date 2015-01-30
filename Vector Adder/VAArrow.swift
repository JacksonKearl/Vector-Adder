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
    override init() {
        super.init(texture: SKTexture(imageNamed: "Arrow"), color: UIColor.blackColor(), size: CGSizeMake(33,24))
        self.centerRect = CGRectMake(5/33.0, 12/24.0, 2/33.0, 3/24.0)
        self.xScale = 4;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
