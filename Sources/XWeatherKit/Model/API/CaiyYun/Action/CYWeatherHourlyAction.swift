//
//  CYWeatherHourlyAction.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/6/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct CYWeatherHourlyAction: CYWeatherAction {
    public typealias Parameters = CYWeatherParameters
    public typealias Response = CYWeatherHourlyResponse
    
    public var host: String { cyweatherHost }
    public var path: String { "/\(parameters!.token)/\(parameters!.longitude),\(parameters!.latitude)/hourly" }
    public var parameters: Parameters?
    public var responseType = Response.self

    public init(parameters: Parameters) {
        self.parameters = parameters
    }
}

public struct CYWeatherHourlyResponse: CYWeatherResponse {

    public struct Result: Codable {
        public var hourly: CYWeatherHourly
        public var primary: Int
        public var forecast_keypoint: String        //自然语言描述
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
