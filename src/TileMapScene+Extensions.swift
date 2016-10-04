//
//  TileMapScene+Extensions.swift
//
//  Created by MARK BROWNSWORD on 5/9/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit

extension TileMapScene {
    
    // MARK: Grid Tile
    
    var gridTile: SKTileGroup {
        guard let selectionTile = self.gridLayer.tileSet.tileGroups.first(where: {$0.name == "Tiles"}) else {
            fatalError("Grid tile not found")
        }
        
        return selectionTile
    }
    
    var gridTileDefinition: SKTileDefinition {
        guard let gridTileSetRule = self.gridTile.rules.first(where: {$0.name == "Tile"}) else {
            fatalError("Grid tileset rule not found")
        }
        
        guard let gridTileDefinition = gridTileSetRule.tileDefinitions.first(where: {$0.name == "Grid"}) else {
            fatalError("Grid tile definition not found")
        }
        
        return gridTileDefinition
    }
    
    
    // MARK: Selection Tile
    
    var selectionTile: SKTileGroup {
        guard let selectionTile = self.selectionLayer.tileSet.tileGroups.first(where: {$0.name == "Tiles"}) else {
            fatalError("Selection tile not found")
        }
        
        return selectionTile
    }
    
    var selectionTileDefinition: SKTileDefinition {
        guard let selectionTileSetRule = self.selectionTile.rules.first(where: {$0.name == "Tile"}) else {
            fatalError("Tileset rule not found")
        }
        
        guard let selectionTileDefinition = selectionTileSetRule.tileDefinitions.first(where: {$0.name == "Selection"}) else {
            fatalError("Tile definition not found")
        }
        
        return selectionTileDefinition
    }
    
    
    // MARK: Functions
    
    func setSelectionTileAt(targetLocation: CGPoint) -> CGPoint? {
        let existingColumn = self.currentSelectionlocation == nil ? -1 : self.selectionLayer.tileColumnIndex(fromPosition: self.currentSelectionlocation!)
        let existingRow = self.currentSelectionlocation == nil ? -1 : self.selectionLayer.tileRowIndex(fromPosition: self.currentSelectionlocation!)
        let newColumn = self.selectionLayer.tileColumnIndex(fromPosition: targetLocation)
        let newRow = self.selectionLayer.tileRowIndex(fromPosition: targetLocation)
        
        // Toggle selection tile if it already exists in the current location
        if (existingColumn == newColumn && existingRow == newRow) {
            self.selectionLayer.setTileGroup(nil, forColumn: existingColumn, row: existingRow)
            return nil
        }
        
        // Remove existing selection tile at specified column and row
        if self.currentSelectionlocation != nil {
            self.selectionLayer.setTileGroup(nil, forColumn: existingColumn, row: existingRow)
        }
        
        // Add selection tile to map at specified column and row
        self.selectionLayer.setTileGroup(self.selectionTile, andTileDefinition: self.selectionTileDefinition, forColumn: newColumn, row: newRow)
        return targetLocation
    }
    
    func floodFillGrid() {
        self.gridLayer.fill(with: self.gridTile)
    }
}
