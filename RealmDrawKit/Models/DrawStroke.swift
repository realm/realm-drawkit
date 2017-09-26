//
//  RealmDrawStroke.swift
//
//  Copyright 2017 Realm Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
