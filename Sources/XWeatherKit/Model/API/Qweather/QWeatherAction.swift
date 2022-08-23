//
//  QWeatherAction.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/4/6.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public enum QWeatherUnit: String {
    case metric = "m"
    case imperial = "i"
}

public protocol QWeatherParameters: XWeatherServerParameters {
    var range: String? { get }       //搜索范围，可设定只在某个国家范围内进行搜索，国家名称需使用ISO 3166 所定义的国家代码
    var number: Int? { get }         //返回结果的数量，取值范围1-20，默认返回10个结果
    var lang: String? { get }        //lowercase 多语言设置，默认中文，当数据不匹配你设置的语言时，将返回英文或其本地语言结果。
    var unit: String? { get }        //度量衡单位参数选择，例如温度选摄氏度或华氏度、公里或英里。默认公制单位 m 公制单位 i 英制单位
    var key: String { get }          //qweather key
}

public protocol QWeatherAction: XWeatherServerAction { }

extension QWeatherAction {
    var geoHost: String { "https://geoapi.qweather.com" }
    var qweatherHost: String { "https://devapi.qweather.com" }
}
