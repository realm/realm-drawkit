//
//  DrawViewController.swift
//  RealmDrawKitExample
//
//  Created by Tim Oliver on 9/7/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController, DrawCanvasViewDelegate {

    override func loadView() {
        let canvasView = DrawCanvasView(frame: .zero)
        canvasView.delegate = self
        self.view = canvasView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func drawCanvasView(_ canvasView: DrawCanvasView, didAddNewStrokeWithWidth width: Double, color: UIColor) {
        print("Created new stroke!")
    }

    func drawCanvasView(_ canvasView: DrawCanvasView, didAddNewPoint point: CGPoint, toStrokeAt index: Int) {
        print("Added point to stroke!")
    }

}
