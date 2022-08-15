//
//  XWWeather.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/24.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct XWWeather: XWWeatherData {
    public var isCurrentLocation: Bool
    public var location: XWWeatherLocation?
    
    public var now: XWWeatherNow
    public var minutely: XWWeatherMinutely
    public var hourly: XWWeatherHourly
    public var daily: XWWeatherDaily
    public var unit: XWTemperature.Unit
    
    public init(isCurrentLocation: Bool = false, location: XWWeatherLocation? = nil, now: XWWeatherNow = XWWeatherNow(), minutely: XWWeatherMinutely = XWWeatherMinutely(), hourly: XWWeatherHourly = XWWeatherHourly(description: "", hourly: []), daily: XWWeatherDaily = XWWeatherDaily(), unit: XWTemperature.Unit = .celsius) {
        self.isCurrentLocation = isCurrentLocation
        self.location = location
        self.now = now
        self.minutely = minutely
        self.hourly = hourly
        self.daily = daily
        self.unit = unit
    }
    
    public func isUpdateValid(timeInterval: TimeInterval) -> Bool {
        if now.updateDate == nil {
            return true
        }
        
        if let date = now.updateDate, Date().timeIntervalSince1970 - date.timeIntervalSince1970 < timeInterval {
            #if DEBUG
            print("Weather refresh abort, TimeInterval: \(timeInterval)")
            #endif
            return false
        } else {
            return true
        }
    }
}

extension XWWeather {
    public init(isCurrentLocation: Bool = false, location: XWWeatherLocation? = nil, unit: XWTemperature.Unit, response: CYWeatherDetailResponse) {
        let now = XWWeatherNow(response.result.realtime)
        let minutely = XWWeatherMinutely(response.result.minutely)
        let hourly = response.result.hourly.asHourly(step: 24)
        let daily = response.result.daily.asDaily(steps: 15)
        
        self.isCurrentLocation = isCurrentLocation
        self.location = location
        self.now = now
        self.minutely = minutely
        self.hourly = hourly
        self.daily = daily
        self.unit = unit
    }
}
