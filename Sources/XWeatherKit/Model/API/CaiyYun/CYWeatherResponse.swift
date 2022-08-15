//
//  CYWeatherResponse.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/30.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public protocol CYWeatherResponse: XWeatherServerResponse {
    associatedtype Result: Codable
    var status: String { get }
    var api_version: String { get }
    var api_status: String { get }
    var lang: String { get }
    var unit: String { get }
    var tzshift: Int { get }
    var timezone: String { get }
    var server_time: Int  { get }
    var location: [Double] { get }
    var result: Result { get }
}

public extension CYWeatherResponse {
    var isSuccess: Bool { status == "OK" }
}

//https://docs.caiyunapp.com/docs/alert
public struct CYWeatherAlert: Codable {
    public struct ADCode: Codable {
        public var adcode: Int
        public var name: String
    }
    
    public struct Content: Codable {
        public var adcode: String               //区域代码，如 "350400"
        public var alertId: String              //预警 ID，如 "35040041600001_20200421123203"
        public var city: String                 //市，如"三明市"
        public var code: String                 //预警代码，如"0902"
        public var county: String               //县，如"无"
        public var description: String          //描述，如"三明市气象台 2020 年 04 月 21 日 12 时 19 分继续发布雷电黄色预警信号：预计未来 6 小时我市有雷电活动，局地伴有短时强降水、6-8 级雷雨大风等强对流天气。请注意防范！"
        public var latlon: [Double]
        public var location: String             //位置，如"福建省三明市"
        public var province: String             //省，如"福建省"
        public var pubtimestamp: Int            //发布时间，单位是 Unix 时间戳，如 1587443583
        public var regionId: String
        public var request_status: String
        public var title: String                //标题，如"三明市气象台发布雷电黄色预警[Ⅲ 级/较重]",
        public var source: String               //发布单位，如"国家预警信息发布中心"
        public var status: String               // 预警信息的状态，如"预警中"
    }
    public var status: String
    public var content: [Content]
    public var adcodes: [ADCode]                //行政区划层级信息
}

public struct CYWeatherRealtime: Codable {
    public struct AirQuality: Codable {
        public struct AQI: Codable {
            public var chn: Int
            public var usa: Int
        }

        public struct Description: Codable {
            public var chn: String
            public var usa: String
        }
        public var pm25: Int
        public var pm10: Int
        public var o3: Int
        public var so2: Int
        public var no2: Int
        public var co: Double
        public var aqi: AQI
        public var description: Description
    }
    
    public struct LifeIndex: Codable {
        public struct ultraviolet: Codable {
            public var index: Int
            public var desc: String
        }
        public struct comfort: Codable {
            public var index: Int
            public var desc: String
        }
    }
    
    public struct Precipitation: Codable {
        public struct Local: Codable {
            public var status: String
            public var datasource: String
            public var intensity: Double
        }

        public struct Nearest: Codable {
            public var status: String
            public var distance: Double
            public var intensity: Double
        }
        public var local: Local
        public var nearest: Nearest
    }
    
    public struct Wind: Codable {
        public var speed: Double
        public var direction: Double
    }
    
    public var status: String
    public var temperature: Double
    public var humidity: Double
    public var cloudrate: Double
    public var skycon: String
    public var visibility: Double
    public var dswrf: Double
    public var wind: Wind
    public var pressure: Double
    public var apparent_temperature: Double
    public var precipitation: Precipitation
    public var air_quality: AirQuality
    public var life_index: LifeIndex
}

public struct CYWeatherMinutely: Codable {
    public var status: String
    public var datasource: String
    public var precipitation_2h: [Double]  //降水强度 表示未来2小时每一分钟的雷达降水强度
    public var precipitation: [Double]     //降水强度 表示未来1小时每一分钟的雷达降水强度
    public var probability: [Double]       //降水概率 表示未来两小时每半小时的降水概率
    public var description: String         //降水描述
}

public struct CYWeatherHourly: Codable {
    public struct AirQuality: Codable {
        public struct AQIValue: Codable {
            public struct Value: Codable {
                public var chn: Int
                public var usa: Int
            }
            public var datetime: String
            public var value: Value
        }
        public var aqi: [AQIValue]                          //国标 AQI
        public var pm25: [WeatherData]                 //PM2.5 浓度(μg/m3)
    }
    
    public struct Precipitation: Codable {
        public var datetime: String
        public var value: Double
        public var probability: Double
    }
    
    public struct Skycon: Codable {
        public var datetime: String
        public var value: String
    }
    
    public struct WeatherData: Codable {
        public var datetime: String
        public var value: Double
    }
    
    public struct Wind: Codable {
        public var datetime: String
        public var speed: Double                       //地表 10 米风速
        public var direction: Double                      //地表 10 米风向
    }
    
    public var status: String
    public var description: String                     //自然语言描述
    public var precipitation: [Precipitation]            //降水数据
    public var temperature: [WeatherData]              //地表 2 米气温
    public var apparent_temperature: [WeatherData]     //体感温度
    public var wind: [Wind]
    public var humidity: [WeatherData]                 //地表 2 米相对湿度(%)
    public var cloudrate: [WeatherData]                //云量(0.0-1.0)
    public var skycon: [Skycon]                        //天气现象
    public var pressure: [WeatherData]                 //地面气压
    public var visibility: [WeatherData]               //地表水平能见度
    public var dswrf: [WeatherData]                    //向下短波辐射通量(W/M2)
    public var air_quality: AirQuality
}

public struct CYWeatherDaily: Codable {
    public struct AirQuality: Codable {
        public struct AQI: Codable {
            public struct AQIValue: Codable {
                public var chn: Int
                public var usa: Int
            }
            public var date: String
            public var avg: AQIValue
            public var max: AQIValue
            public var min: AQIValue
        }
        
        public var aqi: [AQI]                                   //国标 AQI
        public var pm25: [WeatherValue]
    }
    
    public struct Astro: Codable {
        public struct SunTime: Codable {
            public var time: String
        }
        public var date: String
        public var sunrise: SunTime
        public var sunset: SunTime
    }
    
    public struct WeatherValue: Codable {
        public var date: String
        public var avg: Double
        public var max: Double
        public var min: Double
    }
    
    public struct LifeIndex: Codable {
        public struct LifeIndexValue: Codable {
            public var date: String
            public var index, desc: String
        }
        public var carWashing: [LifeIndexValue]     //洗车指数自然语言
        public var coldRisk: [LifeIndexValue]       //感冒指数自然语言
        public var comfort: [LifeIndexValue]        //舒适度指数自然语言
        public var dressing: [LifeIndexValue]       //穿衣指数自然语言
        public var ultraviolet: [LifeIndexValue]    //紫外线指数自然语言
    }
    
    public struct Skycon: Codable {
        public var date: String
        public var value: String
    }
    
    public struct Wind: Codable {
        public struct WindValue: Codable {
            public var speed, direction: Double
        }
        public var date: String
        public var avg: WindValue
        public var max: WindValue
        public var min: WindValue
    }

    
    public var status: String
    public var air_quality: AirQuality                      //空气质量
    public var astro: [Astro]                               //日出日落时间，当地时区的时刻，tzshift 不作用在这个变量)
    public var cloudrate: [WeatherValue]                    //云量(0.0-1.0)
    public var dswrf: [WeatherValue]                        //向下短波辐射通量(W/M2)
    public var humidity: [WeatherValue]                     //地表 2 米相对湿度(%)
    public var precipitation: [WeatherValue]                //降水数据
    public var precipitation_08h_20h: [WeatherValue]        //白天降水数据
    public var precipitation_20h_32h: [WeatherValue]        //夜晚降水数据
    public var pressure: [WeatherValue]                     //地面气压
    public var skycon: [Skycon]                             //全天主要 天气现象
    public var skycon_08h_20h: [Skycon]                     //白天主要 天气现象
    public var skycon_20h_32h: [Skycon]                     //夜晚主要 天气现象
    public var temperature: [WeatherValue]                  //全天地表 2 米气温
    public var temperature_08h_20h: [WeatherValue]          //白天地表 2 米气温
    public var temperature_20h_32h: [WeatherValue]          //夜晚地表 2 米气温
    public var visibility: [WeatherValue]                   //地表水平能见度
    public var wind: [Wind]                                 //全天地表 10 米风速
    public var wind_08h_20h: [Wind]                         //白天地表 10 米风速
    public var wind_20h_32h: [Wind]                         //夜晚地表 10 米风速
    public var life_index: LifeIndex                        //生活指数
}
