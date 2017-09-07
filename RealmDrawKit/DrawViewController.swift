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

    var realmCanvas: RealmDrawCanvas?

    override func loadView() {
        let canvasView = DrawCanvasView(frame: .zero)
        canvasView.delegate = self
        canvasView.dataSource = self
        self.view = canvasView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create canvas for first time
        let realm = try! Realm()
        realmCanvas = realm.objects(RealmDrawCanvas.self).first
        if realmCanvas == nil {
            realmCanvas = RealmDrawCanvas()
            try! realm.write {
                realm.add(realmCanvas!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
