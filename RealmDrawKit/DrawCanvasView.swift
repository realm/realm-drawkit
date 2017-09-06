//
//  RealmDrawCanvas.swift
//  RealmDrawCanvasExample
//
//  Created by Tim Oliver on 9/5/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import UIKit
import QuartzCore

// The delegate reports any user generated input to an external object
public protocol DrawCanvasViewDelegate {
    func drawCanvasView(_ canvasView: DrawCanvasView, didAddNewStrokeWithWidth width: Double, color: UIColor)
    func drawCanvasView(_ canvasView: DrawCanvasView, didAddNewPoint point: CGPoint, toStrokeAt index: Int)
}

// The data source retrieves data from a prior store
public protocol DrawCanvasViewDataSource {
    func numberOfStrokesInDrawCanvasView(_ drawCanvasView: DrawCanvasView) -> Int
    func drawCanvasView(_ canvasView: DrawCanvasView, colorOfStrokeAt index: Int) -> UIColor
    func drawCanvasView(_ canvasView: DrawCanvasView, widthOfStrokeAt index: Int) -> Double
    func drawCanvasView(_ canvasView: DrawCanvasView, numberOfPointsInStroke: Int) -> Int
    func drawCanvasView(_ canvasView: DrawCanvasView, pointInStrokeAt strokeIndex: Int, at pointIndex: Int) -> CGPoint
}

open class DrawCanvasView: UIView {

    // Properties that will control the next stroke to be drawn
    public var strokeColor: UIColor = .black
    public var strokeWidth = 2.0

    public var delegate: DrawCanvasViewDelegate?
    public var dataSource: DrawCanvasViewDataSource?

    // Touch sampling constants
    static let sampleDistance = 1.0
    static let sampleDistanceSquared = sampleDistance * sampleDistance

    // Internal state for all of the strokes this canvas has
    private var strokes = [DrawStroke]()
    private var activeStroke: DrawStroke?
    private var activeStrokeIndex: Int = -1

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setUp() {
        backgroundColor = .white
        contentMode = .redraw
    }

    open override func draw(_ rect: CGRect) {
        backgroundColor!.set()
        UIRectFill(rect)

        let context = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)

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

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Create a new stroke record
        let newStroke = DrawStroke()
        newStroke.color = strokeColor
        newStroke.width = strokeWidth
        strokes.append(newStroke)

        // Inform the delegate of the new stroke
        delegate?.drawCanvasView(self, didAddNewStrokeWithWidth: strokeWidth, color: strokeColor)

        // Keep track of this stroke for subsequent touch events
        activeStroke = newStroke
        activeStrokeIndex = strokes.count - 1

        // Record this initial touch as the origin point
        let touch = touches.first
        let point = touch!.location(in: self)
        newStroke.addPoint(point)

        // Inform the delegate of the new point
        delegate?.drawCanvasView(self, didAddNewPoint: point, toStrokeAt: activeStrokeIndex)

        // Call touches moved to ensure the point is still properly handled
        self.touchesMoved(touches, with: event)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let activeStroke = activeStroke else { return }

        let touch = touches.first
        let point = touch!.location(in: self)

        // Work out the delta between the last point
        let previousPoint = activeStroke.points.last!

        let dx = point.x - previousPoint.x
        let dy = point.y - previousPoint.y

        // The touch didn't move far enough to be worth capturing this new sample
        guard (dx * dx + dy * dy) > CGFloat(DrawCanvasView.sampleDistanceSquared) else { return }

        // Add the new point to the stroke
        activeStroke.addPoint(point)
        activeStroke.isDirty = true

        // Inform the delegate of the new point
        delegate?.drawCanvasView(self, didAddNewPoint: point, toStrokeAt: activeStrokeIndex)

        // Inform the view we need to redraw this region
        setNeedsDisplay(activeStroke.dirtyFrame!)
    }
}
