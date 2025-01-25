//
//  SunKitTests.swift
//  SunKitTests
//
//  Created by Jim Newkirk on 1/20/25.
//

import Testing
import Foundation
import WeatherKit
import CoreLocation
@testable import SunKit


struct SunKitTests {
    var testLocations: [TestLocation] = []
    
    internal init() async throws {
        testLocations = TestLocation.load()
    }
    
    @Test
    func loadingTestLocationArray() async throws {
        try #require(testLocations.count == 246)
    }
    
    @Test
    func sunrise() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.sunrise == model.sunrise,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func sunset() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.sunset == model.sunset,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func astronomicalDawn() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.astronomicalDawn == model.astronomicalDawn,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func astronomicalDusk() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.astronomicalDusk == model.astronomicalDusk,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func civilDawn() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.civilDawn == model.civilDawn,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func civilDusk() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.civilDusk == model.civilDusk,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func nauticalDawn() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.nauticalDawn == model.nauticalDawn,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func nauticalDusk() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.nauticalDusk == model.nauticalDusk,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func morningBlueHour() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.morningBlueHour == model.morningBlueHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func eveningBlueHour() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.eveningBlueHour == model.eveningBlueHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func morningGoldenHour() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.morningGoldenHour == model.morningGoldenHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func eveningGoldenHour() async throws {
        for testLocation in testLocations {
            let sunKit = SunKit(testLocation.coordinate)!
            let model = sunKit.monkey(testLocation.date)
            
            #expect(testLocation.sunModel.eveningGoldenHour == model.eveningGoldenHour,
                    "Test Location: \(testLocation.name)")
        }
    }
    
    @Test
    func isDaylightTrue() async throws {
        let testLocation = try #require(testLocations.first)
        let sunrise = try #require(testLocation.sunModel.sunrise)
        
        let time = sunrise.addingTimeInterval(60 * 60)
        let sunKit = SunKit(testLocation.coordinate)!
        let model = sunKit.monkey(time)
        
        #expect(model.isDaylight)
    }
    
    @Test
    func isDaylightBeforeSunrise() async throws {
        let testLocation = try #require(testLocations.first)
        let sunrise = try #require(testLocation.sunModel.sunrise)
        
        let time = sunrise.addingTimeInterval(-(60 * 60))
        let sunKit = SunKit(testLocation.coordinate)!
        let model = sunKit.monkey(time)
        
        #expect(model.isDaylight == false)
    }
    
    @Test
    func isDaylightAfterSunset() async throws {
        let testLocation = try #require(testLocations.first)
        let sunset = try #require(testLocation.sunModel.sunset)
        
        let time = sunset.addingTimeInterval(60 * 60)
        let sunKit = SunKit(testLocation.coordinate)!
        let model = sunKit.monkey(time)
        
        #expect(model.isDaylight == false)
    }
    
    @Test
    func isDaylightAtSunset() async throws {
        let testLocation = try #require(testLocations.first)
        let sunset = try #require(testLocation.sunModel.sunset)
        
        let sunKit = SunKit(testLocation.coordinate)!
        let model = sunKit.monkey(sunset)
        
        #expect(model.isDaylight == false)
    }
    
    @Test
    func isDaylightAtSunrise() throws {
        let testLocation = try #require(testLocations.first)
        let sunrise = try #require(testLocation.sunModel.sunrise)
        
        let sunKit = SunKit(testLocation.coordinate)!
        let model = sunKit.monkey(sunrise)
        
        #expect(model.isDaylight == true)
    }
    
    @Test
    func noSunriseOccurs() {
        let testDate = Date(timeIntervalSince1970: 1486598400)
        let sunKit = SunKit(CLLocationCoordinate2D(latitude: 78.2186, longitude: 15.64007))!
        let model = sunKit.monkey(testDate)
           
        #expect(model.sunrise == nil)
    }
    
    @Test
    func noSunsetOccurs() {
        let testDate = Date(timeIntervalSince1970: 1486598400)
        let sunKit = SunKit(CLLocationCoordinate2D(latitude: 78.2186, longitude: 15.64007))!
        let model = sunKit.monkey(testDate)
           
        #expect(model.sunset == nil)
    }
    
    @Test
    func invalidCoordinates() throws {
        let invalidCoordinate = CLLocationCoordinate2D(latitude: -100, longitude: 0)
        let sunKit = SunKit(invalidCoordinate)
        
        let _ = try #require(sunKit)
    }
    
    @Test
    func daylightIntervalSeconds() throws {
        let testDate = Date(timeIntervalSince1970: 1737779072)
        let sunKit = SunKit(Constant.Cupertino)!
        let model = sunKit.monkey(testDate)
           
        let daylightInterval = try #require(model.daylight)
        #expect(daylightInterval.duration == 36497.0)
    }
    
    @Test
    func daylightIntervalHoursMinutes() throws {
        let testDate = Date(timeIntervalSince1970: 1737779072)
        let sunKit = SunKit(Constant.Cupertino)!
        let model = sunKit.monkey(testDate)
           
        let daylightInterval = try #require(model.daylight)
        
        let (hours, minutes) = daylightInterval.hoursMinutes()
        #expect(hours == 10)
        #expect(minutes == 8)
    }
}
