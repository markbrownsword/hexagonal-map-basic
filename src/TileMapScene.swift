//
//  TileMapScene.swift
//
//  Created by MARK BROWNSWORD on 5/9/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit

protocol TileMapScene {
    var backgroundLayer: SKTileMapNode! { get set }
    var gridLayer: SKTileMapNode! { get set }
    var selectionLayer: SKTileMapNode! { get set }
    
    var gameCamera: SKCameraNode! { get }
    var gameScene: SKScene! { get }
    var gameScaleMode: SKSceneScaleMode! { get set }
    
    var currentSelectionlocation: CGPoint? { get set }
    var selectionTile: SKTileGroup { get }
    var selectionTileDefinition: SKTileDefinition { get }
    
    func setSelectionTileAt(targetLocation: CGPoint) -> CGPoint?
}
