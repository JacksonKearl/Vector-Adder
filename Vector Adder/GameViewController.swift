//
//  GameViewController.swift
//  Vector Adder
//
//  Created by Jackson Kearl on 1/30/15.
//  Copyright (c) 2015 Jackson Kearl. All rights reserved.
//

import UIKit
import SpriteKit
import iAd


class GameViewController: UIViewController, ADBannerViewDelegate {
    
    var adView:ADBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let iADHeight:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 66 : 50
        adView = ADBannerView(frame: CGRectMake(0, self.view.frame.height-iADHeight, self.view.frame.width, iADHeight))
        adView?.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let skView = self.view as SKView
        
        if skView.scene == nil{
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            let mainMenu = GameScene(size: skView.bounds.size)
            mainMenu.scaleMode = .AspectFill
            
            skView.presentScene(mainMenu)
            
        }
        

    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        banner.removeFromSuperview()
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.view.addSubview(adView!)
    }
    
    

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
