//
//  XWWeatherNow.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct XWWeatherNow: XWWeatherData, XWWeatherDescription {
    public var aqi: XWWeatherAQIType?
    public var description: String?
    public var effectiveTemperature: XWTemperature?
    public var humidity: Double?
    public var temperature: XWTemperature?
    public var updateDate: Date?
    public var visibility: Double?
    public var weatherType: XWWeatherType
    public var windInfo: XWWindInfo?
    
    public init(aqi: XWWeatherAQIType? = nil, description: String? = nil, effectiveTemperature: XWTemperature? = nil, humidity: Double? = nil, temperature: XWTemperature? = nil, updateDate: Date? = nil, visibility: Double? = nil, weathType: XWWeatherType = .unknow, windInfo: XWWindInfo? = nil) {
        self.aqi = aqi
        self.description = description
        self.effectiveTemperature = effectiveTemperature
        self.humidity = humidity
        self.temperature = temperature
        self.updateDate = updateDate
        self.visibility = visibility
        self.weatherType = weathType
        self.windInfo = windInfo
    }
}

extension XWWeatherNow {
    public init(_ now: QWWeatherNowResponse.QWWeatherNow) {
        self.description = now.text
        if let feelsLike = Double(now.feelsLike) {
            self.effectiveTemperature = XWTemperature(unit: .celsius, value: feelsLike)
        }
        self.humidity = Double(now.humidity)
        if let temperature = Double(now.temp) {
            self.temperature = XWTemperature(unit: .celsius, value: temperature)
        }
        self.updateDate = Date()
        self.visibility = Double(now.vis)
        self.weatherType = .init(qwIconCode: now.icon)
        if let angle = Double(now.wind360) {
            self.windInfo = XWWindInfo(direct: .init(angle: angle), level: Int(now.windScale), speed: Double(now.windSpeed))
        }
    }
}

extension XWWeatherNow {
    public init(_ now: CYWeatherRealtime) {
        self.aqi = .aqi(value: Double(now.air_quality.aqi.chn))
        self.description = nil
        self.effectiveTemperature = XWTemperature(unit: .celsius, value: now.apparent_temperature)
        self.humidity = now.humidity
        self.temperature = XWTemperature(unit: .celsius, value: now.temperature)
        self.updateDate = Date()
        self.visibility = now.visibility
        self.weatherType = .init(cywSkycon: now.skycon)
        self.windInfo = XWWindInfo(direct: .init(angle: Double(now.wind.direction)), level: nil, speed: now.wind.speed)
    }
}
