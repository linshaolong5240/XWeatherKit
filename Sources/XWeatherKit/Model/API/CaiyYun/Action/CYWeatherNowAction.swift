//
//  CYWeatherNowAction.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/30.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct CYWeatherNowAction: CYWeatherAction {
    public typealias Parameters = CYWeatherParameters
    public typealias Response = CYWeatherNowResponse
    
    public var host: String { cyweatherHost }
    public var uri: String { "/\(parameters!.token)/\(parameters!.longitude),\(parameters!.latitude)/realtime" }
    public var parameters: Parameters?
    public var responseType = Response.self

    public init(parameters: Parameters) {
        self.parameters = parameters
    }
}

public struct CYWeatherNowResponse: CYWeatherResponse {
    
    public struct Result: Codable {
        public var realtime: CYWeatherRealtime
        public var primary: Int
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
