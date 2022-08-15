//
//  XWWeatherHourly.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/8/9.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct XWWeatherHourly: XWWeatherData {
    public struct Precipitation: Codable {
        public var value: Double
        public var probability: Double
        public var updateDate: Date?
        
        public init(value: Double, probability: Double, updateDate: Date?) {
            self.value = value
            self.probability = probability
            self.updateDate = updateDate
        }
    }
    
    public struct Hourly: Codable, XWWeatherDescription {
        public var apparentTemperature: XWTemperature       //体感温度
        public var aqi: XWWeatherAQIType
        public var cloudrate: Double                        //云量(0.0-1.0)
        public var dswrf: Double                            //向下短波辐射通量(W/M2)
        public var humidity: Double                         //地表 2 米相对湿度(%)
        public var precipitation: Precipitation             //降水数据
        public var pressure: Double                         //地面气压
        public var temperature: XWTemperature?              //地表 2 米气温
        public var updateDate: Date?
        public var visibility: Double                       //地表水平能见度
        public var weatherType: XWWeatherType
        public var wind: XWWindInfo

        public init(apparentTemperature: XWTemperature, aqi: XWWeatherAQIType, cloudrate: Double, dswrf: Double, humidity: Double, precipitation: XWWeatherHourly.Precipitation, pressure: Double, temperature: XWTemperature, updateDate: Date?, visibility: Double, weather: XWWeatherType, wind: XWWindInfo) {
            self.apparentTemperature = apparentTemperature
            self.aqi = aqi
            self.cloudrate = cloudrate
            self.dswrf = dswrf
            self.humidity = humidity
            self.precipitation = precipitation
            self.pressure = pressure
            self.temperature = temperature
            self.updateDate = updateDate
            self.visibility = visibility
            self.weatherType = weather
            self.wind = wind
        }
    }

    public var description: String                      //自然语言描述
    public var hourly: [Hourly]
    
    public init(description: String, hourly: [Hourly] = []) {
        self.description = description
        self.hourly = hourly
    }
}

extension CYWeatherHourly {
    public func asHourly(step: Int) -> XWWeatherHourly {
        var items: [XWWeatherHourly.Hourly] = []
        for i in 0..<step {
            let apparentTemperature = XWTemperature(unit: .celsius, value: apparent_temperature[i].value)
            let aqi = XWWeatherAQIType.aqi(value: Double(air_quality.aqi[i].value.chn))
            let cloudrate = cloudrate[i].value
            let dswrf = dswrf[i].value
            let humidity = humidity[i].value
            let precipitationValue = precipitation[i].value
            let precipitationProbability = precipitation[i].probability
            let precipitationDate = Date(formatterString: "yyyy-MM-dd'T'HH:mmZ", dateString: precipitation[i].datetime)
            let precipitation = XWWeatherHourly.Precipitation(value: precipitationValue, probability: precipitationProbability, updateDate: precipitationDate)
            let pressure = pressure[i].value
            let temperature = XWTemperature(unit: .celsius, value: temperature[i].value)
            let updateDate =  Date(formatterString: "yyyy-MM-dd'T'HH:mmZ", dateString: skycon[i].datetime)
            let visibility = visibility[i].value
            let weather = XWWeatherType(cywSkycon: skycon[i].value)
            let wind = XWWindInfo(direct: .init(angle: Double(wind[i].direction)), level: nil, speed: wind[i].speed)
            let h = XWWeatherHourly.Hourly(apparentTemperature: apparentTemperature, aqi: aqi, cloudrate: cloudrate, dswrf: dswrf, humidity: humidity, precipitation: precipitation, pressure: pressure, temperature: temperature, updateDate: updateDate, visibility: visibility, weather: weather, wind: wind)
            items.append(h)
        }
        
        let hourly = XWWeatherHourly(description: description, hourly: items)

        return hourly
    }
}
