//
//  DrawViewController.swift
//  RealmDrawKitExample
//
//  Created by Tim Oliver on 9/7/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import UIKit
import RealmSwift

class DrawViewController: UIViewController, DrawCanvasViewDelegate, DrawCanvasViewDataSource {

    let realmQueue = DispatchQueue(label: "io.realm.drawkit",
                                   qos: .userInitiated,
                                   attributes: [], autoreleaseFrequency: .inherit, target: nil)

    var realmCanvas: RealmDrawCanvas? {
        didSet { setUpNewCanvas() }
    }

    var notificationToken: NotificationToken?

    var canvasView: DrawCanvasView {
        return self.view as! DrawCanvasView
    }

    override func loadView() {
        let canvasView = DrawCanvasView(frame: .zero)
        canvasView.delegate = self
        canvasView.dataSource = self
        canvasView.isUserInteractionEnabled = false
        self.view = canvasView
    }

    private func setUpNewCanvas() {
        self.notificationToken = self.realmCanvas?.strokes.addNotificationBlock { changes in
            self.updateFromRealm(with: changes)
        }

        self.canvasView.isUserInteractionEnabled = true
        self.canvasView.reloadCanvasView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Realm Notifications -
    private func updateFromRealm(with changes: RealmCollectionChange<List<RealmDrawStroke>>) {
        switch changes {
        case .update(_, _, let insertions, let modifications):
            // Insertions indicates a new stroke was added
            if insertions.count > 0 && canvasView.numberOfStrokes < realmCanvas!.strokes.count { // A new stroke was added
                for strokeIndex in insertions {
                    canvasView.insertNewStroke(at: strokeIndex)
                }
            }

            // Modifications only indicate a stroke was 'changed'. So we need to check each stroke and ensure
            // the number of points in each one is unchanged
            if modifications.count > 0 {
                for strokeIndex in modifications {
                    let numberOfCanvasPoints = canvasView.numberOfPoints(in: strokeIndex)
                    let pointDelta = realmCanvas!.strokes[strokeIndex].points.count - numberOfCanvasPoints
                    if pointDelta <= 0 { continue }

                    for pointIndex in numberOfCanvasPoints..<(numberOfCanvasPoints + pointDelta) {
                        canvasView.insertNewPoint(in: strokeIndex, at: pointIndex)
                    }
                }
            }

        default: break
        }
    }

    // MARK: - Canvas View Delegate -

    func drawCanvasView(_ canvasView: DrawCanvasView, didAddNewStrokeWithWidth width: Double, color: UIColor) {
        let realmConfiguration = realmCanvas!.realm?.configuration
        let canvasRef = ThreadSafeReference(to: realmCanvas!)

        realmQueue.sync {
            autoreleasepool {
                let newStroke = RealmDrawStroke()
                newStroke.color = color
                newStroke.width = width

                let threadRealm = try! Realm(configuration: realmConfiguration!)
                let threadRealmCanvas = threadRealm.resolve(canvasRef)
                try! threadRealm.write {
                    threadRealmCanvas?.strokes.append(newStroke)
                }
            }
        }
    }

    func drawCanvasView(_ canvasView: DrawCanvasView, didAddNewPoint point: CGPoint, toStrokeAt index: Int) {
        let realmConfiguration = realmCanvas!.realm?.configuration
        let canvasRef = ThreadSafeReference(to: realmCanvas!)

        realmQueue.sync {
            autoreleasepool {
                let threadRealm = try! Realm(configuration: realmConfiguration!)
                let threadRealmCanvas = threadRealm.resolve(canvasRef)

                // ensure the live objects are completely up-to-date
                threadRealm.refresh()

                let stroke = threadRealmCanvas?.strokes[index]

                let newPoint = RealmDrawPoint()
                newPoint.x = Double(point.x)
                newPoint.y = Double(point.y)

                try! threadRealm.write {
                    stroke?.points.append(newPoint)
                }
            }
        }
    }

    // MARK: Persistent Data Source

    func numberOfStrokesInDrawCanvasView(_ drawCanvasView: DrawCanvasView) -> Int {
        guard realmCanvas != nil else { return 0 }
        return realmCanvas!.strokes.count
    }
    func drawCanvasView(_ canvasView: DrawCanvasView, colorOfStrokeAt index: Int) -> UIColor {
        return realmCanvas!.strokes[index].color
    }
    func drawCanvasView(_ canvasView: DrawCanvasView, widthOfStrokeAt index: Int) -> Double {
        return realmCanvas!.strokes[index].width
    }

    func drawCanvasView(_ canvasView: DrawCanvasView, numberOfPointsInStroke strokeIndex: Int) -> Int {
        return realmCanvas!.strokes[strokeIndex].points.count
    }

    func drawCanvasView(_ canvasView: DrawCanvasView, pointInStrokeAt strokeIndex: Int, at pointIndex: Int) -> CGPoint {
        return realmCanvas!.strokes[strokeIndex].points[pointIndex].point
    }
}
