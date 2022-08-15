//
//  XWWeatherDescription.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/7/19.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public protocol XWWeatherDescription {
    var aqi: XWWeatherAQIType? { get }
    var effectiveTemperature: Double? { get }
    var humidity: Double? { get }
    
    var temperature: XWTemperature? { get }
    var temperatureMax: XWTemperature? { get }
    var temperatureMin: XWTemperature? { get }
    
    var updateDate: Date? { get }
    var visibility: Double? { get }
}

extension XWWeatherDescription {
    public var aqi: XWWeatherAQIType? { nil }
    public var effectiveTemperature: Double? { nil }
    public var humidity: Double? { nil }
    
    public var temperature: XWTemperature? { nil }
    public var temperatureMax: XWTemperature? { nil }
    public var temperatureMin: XWTemperature? { nil }
    
    public func temperature(for unit: XWTemperature.Unit) -> Double? {
        guard let temp = temperature else {
            return nil
        }
        switch unit {
        case .celsius:
            return temp.celsius
        case .fahrenheit:
            return temp.fahrenheit
        }
    }
    
    public func temperatureMax(for unit: XWTemperature.Unit) -> Double? {
        guard let temp = temperatureMax else {
            return nil
        }
        switch unit {
        case .celsius:
            return temp.celsius
        case .fahrenheit:
            return temp.fahrenheit
        }
    }

    public func temperatureMin(for unit: XWTemperature.Unit) -> Double? {
        guard let temp = temperatureMin else {
            return nil
        }
        switch unit {
        case .celsius:
            return temp.celsius
        case .fahrenheit:
            return temp.fahrenheit
        }
    }
    
    public var updateDate: Date? { nil }
    public var visibility: Double? { nil }
}

extension XWWeatherDescription {
    public var noDataString: String { "-" }
    
    //AQI
    public var aqiString: String { aqi == nil ? noDataString : "\(aqi!.value)" }
    public var aqiLevelDescription: String { aqi == nil ? noDataString : aqi!.levelDescription }
    public var effectiveTemperatureString: String { effectiveTemperature == nil ? "-" : "\(Int(effectiveTemperature!))" }
    public var humidityString: String { humidity == nil ? noDataString : "\(Int(humidity!))" }
    
    public func temperatureString(for unit: XWTemperature.Unit) -> String {
        guard let temp = temperature(for: unit) else {
            return noDataString
        }
        return String(Int(temp.rounded()))
    }
    
    public func temperatureMaxString(for unit: XWTemperature.Unit) -> String {
        guard let temp = temperatureMax(for: unit) else {
            return noDataString
        }
        return String(Int(temp.rounded()))
    }
    
    public func temperatureMinString(for unit: XWTemperature.Unit) -> String {
        guard let temp = temperatureMin(for: unit) else {
            return noDataString
        }
        return String(Int(temp.rounded()))
    }
        
    public var updateTimeString: String { updateDate == nil ? noDataString : updateDate!.formatString("MM/dd HH:mm") }
    public var visibilityString: String { visibility == nil ? noDataString : "\(Int(visibility!))" }
}
