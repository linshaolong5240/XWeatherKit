//
//  QWeatherSearchCityAction.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/4/18.
//  Copyright © 2022 com.teenloong.com. All rights reserved.
//

import Foundation

public struct QWeatherSearchCityAction: QWeatherAction {
    public struct QWSearchCityParameters: QWeatherParameters {
        public var location: String     //需要查询地区的名称，支持文字、以英文逗号分隔的经度,纬度坐标（十进制，最多支持小数点后两位）、LocationID或Adcode（仅限中国城市）。例如 location=北京 或 location=116.41,39.92
        public var adm: String?         //城市的上级行政区划，默认不限定行政区划。 可设定只在某个行政区划范围内进行搜索，用于排除重名城市或对结果进行过滤。例如 adm=beijing
        public var range: String?
        public var number: Int?
        public var lang: String?
        public var unit: String?
        public var key: String

        public init(searchKey: String, adm: String? = nil, range: String? = nil, number: Int? = nil, lang: String? = nil, key: String) {
            self.location = searchKey
            self.adm = adm
            self.range = range
            self.number = number
            self.lang = lang
            self.key = key
        }
    }
    public typealias Parameters = QWSearchCityParameters
    public typealias Response = QWeatherSearchCityResponse
    
    public var host: String { geoHost }
    public var uri: String { "/v2/city/lookup" }
    public var parameters: Parameters?
    public var responseType = Response.self

    public init(parameters: Parameters) {
        self.parameters = parameters
    }
}


public struct QWeatherSearchCityResponse: QWeatherResponse {
    public var code: String
    public var location: [QWeatherLocation]
    public var refer: QWeatherRefer
}
