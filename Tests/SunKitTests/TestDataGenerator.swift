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
    func generateLunarData() {
        let waypoints = Waypoint.load()
        var newLunarData: [TestLunarData] = []
        
        let firstWaypoint = waypoints.first!
        let date = "2025-03-28T00:48:00Z".toDate()!
        
        for index in 0...29 {
            let currentDate = date.add(days: index)
            let lunar = Lunar(date: currentDate, coordinate: firstWaypoint.coordinate, timeZone: firstWaypoint.timeZone)
            
            newLunarData.append(lunar.testLunarData(currentDate, waypoint: firstWaypoint))
        }

        for waypoint in waypoints.dropFirst() {
            let lunar = Lunar(date: date, coordinate: waypoint.coordinate, timeZone: waypoint.timeZone)
            
            newLunarData.append(lunar.testLunarData(date, waypoint: waypoint))
        }
        
        TestLunarData.save(newLunarData)
    }
    
    @Test
    func generateSolarData() {
        let waypoints = Waypoint.load()
        var newSolarData: [TestSolarData] = []
        let date = "2025-03-28T00:48:00Z".toDate()!

        for waypoint in waypoints {
            let solar = Solar(date: date, coordinate: waypoint.coordinate, timeZone: waypoint.timeZone)
            
            newSolarData.append(solar.testSolarData(date, waypoint: waypoint))
        }
        
        TestSolarData.save(newSolarData)
    }
}
