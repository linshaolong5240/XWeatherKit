//
//  QWeatherNowAction.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/4/18.
//  Copyright © 2022 com.teenloong.com. All rights reserved.
//

import Foundation

public struct QWeatherNowAction: QWeatherAction {
    public struct QWWeatherNowParameters: QWeatherParameters {
        public var location: String     //需要查询地区的LocationID或以英文逗号分隔的经度,纬度坐标（十进制，最多支持小数点后两位），LocationID可通过城市搜索服务获取。例如 location=101010100 或 location=116.41,39.92
        public var range: String?
        public var number: Int?
        public var lang: String?
        public var unit: String?
        public var key: String
        
        public init(longitude: String, latitude: String, unit: QWeatherUnit? = nil, lang: String? = nil, key: String) {
            self.location = "\(longitude),\(latitude)"
            self.unit = unit?.rawValue
            self.lang = lang
            self.key = key
        }
    }
    public typealias Parameters = QWWeatherNowParameters
    public typealias Response = QWWeatherNowResponse
    
    public var host: String { qweatherHost }
    public var path: String { "/v7/weather/now" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(parameters: Parameters) {
        self.parameters = parameters
    }
}


public struct QWWeatherNowResponse: QWeatherResponse {
    public struct QWWeatherNow: Codable {
        public var cloud: String?                  //云量，百分比数值。可能为空
        public var dew: String?                    //露点温度。可能为空
        public var feelsLike: String               //体感温度，默认单位：摄氏度
        public var humidity: String                //相对湿度，百分比数值
        public var icon: String                    //天气状况和图标的代码，图标可通过天气状况和图标下载
        public var obsTime: String                 //数据观测时间
        public var precip: String                  //当前小时累计降水量，默认单位：毫米
        public var pressure: String                //大气压强，默认单位：百帕
        public var temp: String                    //温度，默认单位：摄氏度
        public var text: String                    //天气状况的文字描述，包括阴晴雨雪等天气状态的描述
        public var vis: String                     //能见度，默认单位：公里
        public var wind360: String                 //风向360角度
        public var windDir: String                 //风向
        public var windScale: String               //风力等级
        public var windSpeed: String               //风速，公里/小时
    }
    public var code: String
    public var fxLink: String               //当前数据的响应式页面，便于嵌入网站或应用
    public var now: QWWeatherNow
    public var refer: QWeatherRefer         //原始数据来源
    public var updateDate: String           //当前API的最近更新时间
}
