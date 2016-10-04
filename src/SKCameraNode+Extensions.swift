//
//  SKCameraNode+Extensions.swift
//
//  Created by MARK BROWNSWORD on 16/8/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import SpriteKit

extension SKCameraNode {
    func updateScaleFor(userInterfaceIdiom: UIUserInterfaceIdiom, isLandscape: Bool) {
        switch userInterfaceIdiom {
            case .phone:
                self.setScale(isLandscape ? 0.75 : 1.0)
            case .pad:
                self.setScale(isLandscape ? 1.0 : 1.25)
            default:
                break
        }
    }
    
    func updateBoundaryPositionX(_ x: SKRange, y: SKRange) {
        if (self.position.x < x.lowerLimit) {
            self.position.x = x.lowerLimit
        } else if (self.position.x > x.upperLimit) {
            self.position.x = x.upperLimit
        }
        
        if (self.position.y < y.lowerLimit) {
            self.position.y = y.lowerLimit
        } else if (self.position.y > y.upperLimit) {
            self.position.y = y.upperLimit
        }
    }
    
    func updateConstraintsFor(backgroundLayer: SKTileMapNode, boundaryRangeX: SKRange, boundaryRangeY: SKRange) {
        let levelEdgeConstraint = SKConstraint.positionX(boundaryRangeX, y: boundaryRangeY)
        levelEdgeConstraint.referenceNode = backgroundLayer
        
        self.constraints = [levelEdgeConstraint]
    }
}
