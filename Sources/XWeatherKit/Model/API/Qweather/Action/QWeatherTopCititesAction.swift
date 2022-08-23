//
//  QWeatherTopCititesAction.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/4/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct QWeatherTopCititesAction: QWeatherAction {
    public struct QWeatherTopCititesParameters: QWeatherParameters {
        public var range: String?
        public var number: Int?
        public var lang: String?
        public var unit: String?
        public var key: String
        
        public init(range: String? = nil, number: Int? = nil, lang: String? = nil, key: String) {
            self.range = range
            self.number = number
            self.lang = lang
            self.key = key
        }
    }
    
    public typealias Parameters = QWeatherTopCititesParameters
    public typealias Response = QWeatherTopCititesResponse
    
    public var host: String { geoHost }
    public var path: String { "/v2/city/top" }
    public var parameters: Parameters?
    public var responseType = Response.self
    
    public init(parameters: Parameters) {
        self.parameters = parameters
    }
}

public struct QWeatherTopCititesResponse: QWeatherResponse {
    public var code: String
    public var topCityList: [QWeatherLocation]
    public var refer: QWeatherRefer
}
