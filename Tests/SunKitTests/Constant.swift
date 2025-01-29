//
//  Constant.swift
//  SunKitTests
//
//  Created by James Newkirk on January, 23. 2025.
//  Copyright © 2025 James Newkirk. All rights reserved.
//

import Foundation
import CoreLocation

struct Constant {
    static let testLocationFile = "testLocations"
}

extension Constant {
    static var Cupertino: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 37.322998, longitude: -122.032181)
    }
}
