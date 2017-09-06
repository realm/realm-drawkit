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
    @objc dynamic var color = "#000000"
    let points = List<RealmDrawPoint>()
}
