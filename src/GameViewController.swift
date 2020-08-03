//
//  GameViewController.swift
//
//  Created by MARK BROWNSWORD on 24/7/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    private var sceneNode: TileMapScene!
    
    
    // MARK: Property Overrides
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: Function overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "LandingScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! TileMapScene? {
                self.sceneNode = sceneNode
                
                // Copy gameplay related content over to the scene
                //self.sceneNode.entities = scene.entities
                //self.sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                self.sceneNode.gameScaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(self.sceneNode.gameScene)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
      let isLandscape = UIDevice.current.orientation.isLandscape
        let boundaryRangeXInput = (self.view?.bounds.size.width)!
        let boundaryRangeYInput = (self.view?.bounds.size.height)!
        let boundaryRangeX = self.sceneNode.backgroundLayer.getBoundaryRangeX(boundaryRangeXInput)
        let boundaryRangeY = self.sceneNode.backgroundLayer.getBoundaryRangeY(boundaryRangeYInput)
        
        guard let camera = self.sceneNode.gameCamera else {
            fatalError("Camera not found")
        }
        
        // Update camera scale for device / orientation
        camera.updateScaleFor(userInterfaceIdiom: userInterfaceIdiom, isLandscape: isLandscape)
        
        // Move camera position within boundary (on device rotation)
        camera.updateBoundaryPositionX(boundaryRangeX, y: boundaryRangeY)
        
        // Set camera boundary constraints (on load and on device rotation)
        camera.updateConstraintsFor(backgroundLayer: self.sceneNode.backgroundLayer, boundaryRangeX: boundaryRangeX, boundaryRangeY: boundaryRangeY)
    }
}
