//
//  RealmDrawCanvas.swift
//  RealmDrawKitExample
//
//  Created by Tim Oliver on 9/6/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDrawCanvas: Object {
    let strokes = List<RealmDrawStroke>()
}
