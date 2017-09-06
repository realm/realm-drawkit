//
//  ViewController.swift
//  RealmDrawCanvasExample
//
//  Created by Tim Oliver on 9/5/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let canvasView = RealmDrawCanvas(frame: view.bounds)
        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(canvasView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

