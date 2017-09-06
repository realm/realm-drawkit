//
//  RealmDrawCanvas.swift
//  RealmDrawCanvasExample
//
//  Created by Tim Oliver on 9/5/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import UIKit
import QuartzCore

class RealmDrawCanvas: UIView {

    public var strokeColor: UIColor = .black
    public var strokeWidth = 2.0

    // Touch sampling constants
    static let sampleDistance = 1.0
    static let sampleDistanceSquared = sampleDistance * sampleDistance

    // Internal state for all of the strokes this canvas has
    private var strokes = [RealmDrawStroke]()
    private var activeStroke: RealmDrawStroke?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setUp() {
        backgroundColor = .white
        contentMode = .redraw
    }

    internal override func draw(_ rect: CGRect) {
        backgroundColor!.set()
        UIRectFill(rect)

        let context = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)

        // TODO: Intelligently only update the strokes that need updating
        for stroke in strokes {
            guard stroke.isDirty else { continue }

            context.saveGState()
            context.setLineWidth(CGFloat(stroke.width))
            context.setStrokeColor(stroke.color.cgColor)
            context.addPath(stroke.path)
            context.strokePath()
            context.restoreGState()
        }
    }

    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Create a new stroke record
        let newStroke = RealmDrawStroke()
        newStroke.color = strokeColor
        newStroke.width = strokeWidth
        strokes.append(newStroke)

        // Keep track of this stroke for subsequent touch events
        activeStroke = newStroke

        // Record this initial touch as the origin point
        let touch = touches.first
        let point = touch!.location(in: self)
        newStroke.addPoint(point)

        // Call touches moved to ensure the point is still properly handled
        self.touchesMoved(touches, with: event)
    }

    internal override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let activeStroke = activeStroke else { return }

        let touch = touches.first
        let point = touch!.location(in: self)

        // Work out the delta between the last point
        let previousPoint = activeStroke.points.last!

        let dx = point.x - previousPoint.x
        let dy = point.y - previousPoint.y

        // The touch didn't move far enough to be worth capturing this new sample
        guard (dx * dx + dy * dy) > CGFloat(RealmDrawCanvas.sampleDistanceSquared) else { return }

        // Add the new point to the stroke
        activeStroke.addPoint(point)
        activeStroke.isDirty = true

        // Inform the view we need to redraw this region
        setNeedsDisplay(activeStroke.dirtyFrame!)
    }
}
