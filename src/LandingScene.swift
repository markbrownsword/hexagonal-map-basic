//
//  GameScene.swift
//
//  Created by MARK BROWNSWORD on 24/7/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit
import GameplayKit

class LandingScene: GameSceneBase, TileMapScene {
    
    
    // MARK: Public Properties
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var backgroundLayer: SKTileMapNode!
    var gridLayer: SKTileMapNode!
    var selectionLayer: SKTileMapNode!
    
    var currentSelectionlocation: CGPoint?
    
    var gameCamera: SKCameraNode! {
        return self.camera
    }
    
    var gameScene: SKScene! {
        return self
    }
    
    var gameScaleMode: SKSceneScaleMode! {
        get {
            return self.scaleMode
        }
        set {
            self.scaleMode = newValue
        }
    }
    
    private var lastUpdateTime : TimeInterval = 0
    
    
    // MARK: Override Functions
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        guard let backgroundLayer = childNode(withName: "background") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }
        
        guard let gridLayer = childNode(withName: "grid") as? SKTileMapNode else {
            fatalError("Grid node not loaded")
        }
        
        guard let selectionLayer = childNode(withName: "selection") as? SKTileMapNode else {
            fatalError("Selection node not loaded")
        }
        
        guard let camera = self.childNode(withName: "gameCamera") as? SKCameraNode else {
            fatalError("Camera node not loaded")
        }
        
        self.backgroundLayer = backgroundLayer
        self.gridLayer = gridLayer
        self.selectionLayer = selectionLayer
        self.camera = camera
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressFrom(recognizer:)))
        longPressRecognizer.minimumPressDuration = 1
        view.addGestureRecognizer(longPressRecognizer)
        
        // Add the grid tile to GridLayer
        self.floodFillGrid()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    
    // MARK: GestureRecognizer functions
    @objc
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        if recognizer.state != .changed {
            return
        }
        
        // Get touch delta
        let translation = recognizer.translation(in: recognizer.view!)
        
        // Move camera
        self.camera?.position.x -= translation.x
        self.camera?.position.y += translation.y
        
        // Reset
        recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
    }
    
  @objc
    func handleTapFrom(recognizer: UITapGestureRecognizer) {
        if recognizer.state != .ended {
            return
        }
        
        let location = recognizer.location(in: recognizer.view!)
        let targetLocation = self.convertPoint(fromView: location)
        
        // Don't allow selection of obstacle tiles
        if self.isObstacleAt(targetLocation: targetLocation) {
            return
        }
        
        // Show the selection tile at the current location
        // Update the currently selected location
        self.currentSelectionlocation = self.setSelectionTileAt(targetLocation: targetLocation)
    }
    
  @objc
    func handleLongPressFrom(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        
        // Toggle visibility of gridLayer
        self.gridLayer.isHidden = !self.gridLayer.isHidden
    }
    
    
    // MARK: Private functions
    
    private func isObstacleAt(targetLocation: CGPoint) -> Bool {
        let isObstacle = self.backgroundLayer.getUserData(forKey: "isObstacle", location: targetLocation) as? Int
        
        return isObstacle == 1
    }
}
