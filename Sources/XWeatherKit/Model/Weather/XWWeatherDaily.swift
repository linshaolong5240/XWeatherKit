//
//  XWWeatherDaily.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/7/19.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct XWWeatherDaily: XWWeatherData {
    
    public struct Daily: Codable, XWWeatherDescription {
        public var temperature: XWTemperature?
        public var temperatureMax: XWTemperature?
        public var temperatureMin: XWTemperature?
        public var weatherType: XWWeatherType
        public var updateDate: Date?
        
        public init(temperature: XWTemperature? = nil, temperatureMax: XWTemperature? = nil, temperatureMin: XWTemperature? = nil, weathType: XWWeatherType = .unknow, updateDate: Date? = nil) {
            self.temperature = temperature
            self.temperatureMax = temperatureMax
            self.temperatureMin = temperatureMin
            self.weatherType = weathType
            self.updateDate = updateDate
        }
    }
    
    public var daily: [Daily]
    
    public init(daily: [Daily] = []) {
        self.daily = daily
    }
}

extension CYWeatherDaily {
    public func asDaily(steps: Int) -> XWWeatherDaily {
        var items: [XWWeatherDaily.Daily] = []
        
        for i in 0..<steps {
            let temperature = XWTemperature(unit: .celsius, value: self.temperature[i].avg)
            let temperatureMax = XWTemperature(unit: .celsius, value: self.temperature[i].max)
            let temperatureMin = XWTemperature(unit: .celsius, value: self.temperature[i].min)
            let weatherType = XWWeatherType(cywSkycon: self.skycon[i].value)
            let updateDate = Date(formatterString: "yyyy-MM-dd'T'HH:mmZ", dateString: self.skycon[i].date)
            let item = XWWeatherDaily.Daily(temperature: temperature, temperatureMax: temperatureMax, temperatureMin: temperatureMin, weathType: weatherType, updateDate: updateDate)
            items.append(item)
        }
        
        return XWWeatherDaily(daily: items)
    }
}
