//
//  SKTileMapNode+Extensions.swift
//
//  Created by MARK BROWNSWORD on 20/8/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit

extension SKTileMapNode {
    private func getMinMapBoundaryFor(input: CGFloat) -> CGFloat {
        return min(input * -1 / 2, 0) // Negative
    }
    
    private func getMaxMapBoundaryFor(input: CGFloat) -> CGFloat {
        return max(input / 2, 0) // Positive
    }
    
    func getBoundaryRangeX(_ viewWidth: CGFloat) -> SKRange {
        let boundaryInputX = self.calculateAccumulatedFrame().width - viewWidth
        let boundaryMinX = self.getMinMapBoundaryFor(input: boundaryInputX)
        let boundaryMaxX = self.getMaxMapBoundaryFor(input: boundaryInputX)
        
        return SKRange(lowerLimit: boundaryMinX, upperLimit: boundaryMaxX)
    }
    
    func getBoundaryRangeY(_ viewHeight: CGFloat) -> SKRange {
        let boundaryInputY = self.calculateAccumulatedFrame().height - viewHeight
        let boundaryMinY = self.getMinMapBoundaryFor(input: boundaryInputY)
        let boundaryMaxY = self.getMaxMapBoundaryFor(input: boundaryInputY)
        
        return SKRange(lowerLimit: boundaryMinY, upperLimit: boundaryMaxY)
    }
    
    func getTile(location: CGPoint) -> SKTileDefinition? {
        let column = self.tileColumnIndex(fromPosition: location)
        let row = self.tileRowIndex(fromPosition: location)
        
        return self.tileDefinition(atColumn: column, row: row)
    }
    
    func getUserData(forKey key: String, location: CGPoint) -> Any? {
        let tile = self.getTile(location: location)
        return tile?.userData?.value(forKey: key)
    }
}
