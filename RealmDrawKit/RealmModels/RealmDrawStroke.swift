//
//  RealmDrawStroke.swift
//  RealmDrawKitExample
//
//  Created by Tim Oliver on 9/6/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDrawStroke: Object {
    @objc dynamic var width = 2.0
    @objc dynamic var colorString = "0x000000"
    let points = List<RealmDrawPoint>()

    var color: UIColor {
        set { self.colorString = newValue.toHexString }
        get { return UIColor(hex: self.colorString) }
    }
}
