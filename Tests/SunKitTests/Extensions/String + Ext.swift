//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Foundation

extension String {
    public func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        
        return formatter.date(from: self)
    }
}
