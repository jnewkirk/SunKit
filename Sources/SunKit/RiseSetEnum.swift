//
//  RiseSetEnum.swift
//  SunKit
//
//  Created by Jim Newkirk on 4/17/25.
//

import Foundation

public enum RiseSetEnum: Sendable {
    case rise
    case set

    func value(of: RiseSet) -> Date? {
        switch self {
        case .rise:
            return of.rise
        case .set:
            return of.set
        }
    }
}
