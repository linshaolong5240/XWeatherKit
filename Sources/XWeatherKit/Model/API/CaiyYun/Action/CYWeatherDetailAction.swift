//
//  CYWeatherDailyAction.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/8/2.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct CYWeatherDetailAction: CYWeatherAction {
    public typealias Parameters = CYWeatherParameters
    public typealias Response = CYWeatherDetailResponse
    
    public var host: String { cyweatherHost }
    public var path: String { "/\(parameters!.token)/\(parameters!.longitude),\(parameters!.latitude)/weather" }
    public var parameters: Parameters?
    public var responseType = Response.self

    public init(parameters: Parameters) {
        self.parameters = parameters
    }
}

public struct CYWeatherDetailResponse: CYWeatherResponse {
    //https://docs.caiyunapp.com/docs/weather
    public struct Result: Codable {
        public var alert: CYWeatherAlert?
        public var realtime: CYWeatherRealtime
        public var minutely: CYWeatherMinutely
        public var hourly: CYWeatherHourly
        public var daily: CYWeatherDaily
        public var primary: Int
        public var forecast_keypoint: String
    }
    
    public var status: String
    public var api_version: String
    public var api_status: String
    public var lang: String
    public var unit: String
    public var tzshift: Int
    public var timezone: String
    public var server_time: Int
    public var location: [Double]
    public var result: Result
}
