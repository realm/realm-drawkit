//
//  RealmDrawStroke.swift
//  RealmDrawCanvasExample
//
//  Created by Tim Oliver on 9/6/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import UIKit

extension CGPoint {
    public func mid(with point: CGPoint) -> CGPoint {
        return CGPoint(x: (self.x + point.x) * 0.5,
                       y: (self.y + point.y) * 0.5)
    }
}

class DrawStroke {
    // The color of this stroke. Black by default
    var color: UIColor = .black

    // The thickness of the stroke, in iOS points
    var width = 2.0

    // An array storing all of the points in this stroke
    var points = [CGPoint]()

    // The path making up this stroke
    let path = CGMutablePath()

    // After adding a point, the region that should be updated by the renderer
    var dirtyFrame: CGRect?

    // A stroke can mark itself dirty to indicate it needs redrawing
    var isDirty = false

    // Add a point to the stroke and append it to the mutable path
    public func addPoint(_ point: CGPoint) {
        points.append(point)

        // Add this point to the CG path
        var previousPreviousPoint = points.first!
        var previousPoint = points.first!
        let currentPoint = points.last!

        if points.count > 3 {
            previousPreviousPoint = points[points.count - 3]
        }

        if points.count > 2 {
            previousPoint = points[points.count - 2]
        }

        let mid1 = previousPoint.mid(with: previousPreviousPoint)
        let mid2 = currentPoint.mid(with: previousPoint)

        let subpath = CGMutablePath()
        subpath.move(to: mid1)
        subpath.addQuadCurve(to: mid2, control: previousPoint)

        path.addPath(subpath)

        // compute the dirty rect
        let bounds = subpath.boundingBox
        dirtyFrame = bounds.insetBy(dx: CGFloat(-2.0 * width), dy: CGFloat(-2.0 * width))
    }
}
