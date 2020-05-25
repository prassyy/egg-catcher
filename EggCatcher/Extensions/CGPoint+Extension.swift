//
//  CGPoint+Extension.swift
//  EggCatcher
//
//  Created by Prassyy on 23/05/20.
//  Copyright © 2020 prassy. All rights reserved.
//

import CoreGraphics

public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
