//
//  TestDataGenerator.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/14/25.
//

import CoreLocation
import SwiftAA
import Testing
@testable import SunKit

@Suite(.disabled())
struct TestDataGenerator {
    @Test
    func generateLunarData() async throws {
        let waypoints = Waypoint.load()
        var newLunarData: [TestLunarData] = []
        
        let firstWaypoint = waypoints.first!
        let date = Date.now.withoutNanoseconds()
        
        for index in 0...29 {
            let currentDate = date.add(days: index)
            let solar = try! Solar.make(date: currentDate, coordinate: firstWaypoint.coordinate, timeZone: firstWaypoint.timeZone)
            
            newLunarData.append(solar.testLunarData(currentDate, waypoint: firstWaypoint))
        }

        for waypoint in waypoints.dropFirst() {
            let solar = try! Solar.make(date: date, coordinate: waypoint.coordinate, timeZone: waypoint.timeZone)
            
            newLunarData.append(solar.testLunarData(date, waypoint: waypoint))
        }
        
        TestLunarData.save(newLunarData)
    }
    
    @Test
    func generateSolarData() async throws {
        let waypoints = Waypoint.load()
        var newSolarData: [TestSolarData] = []
        let date = Date.now.withoutNanoseconds()
        
        for waypoint in waypoints {
            let solar = try! Solar.make(date: date, coordinate: waypoint.coordinate, timeZone: waypoint.timeZone)
            
            newSolarData.append(solar.testSolarData(date, waypoint: waypoint))
        }
        
        TestSolarData.save(newSolarData)
    }
}
