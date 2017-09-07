//
//  RealmDrawPoint.swift
//  RealmDrawKitExample
//
//  Created by Tim Oliver on 9/6/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import Foundation
import RealmSwift

open class RealmDrawPoint: Object {
    @objc dynamic var x = 0.0
    @objc dynamic var y = 0.0

    public var point: CGPoint {
        get { return CGPoint(x: x, y: y) }
        set { self.x = Double(newValue.x); self.y = Double(newValue.y) }
    }
}
