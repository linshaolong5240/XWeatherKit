//
//  QWeatherResponse.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/4/18.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public protocol QWeatherResponse: XWeatherServerResponse {
    var code: String { get }
}

public extension QWeatherResponse {
    var isSuccess: Bool { code == "200" }
}

public struct QWeatherLocation: Codable {
    public var adm1: String         //地区/城市所属一级行政区域
    public var adm2: String         //地区/城市的上级行政区划名称
    public var country: String      //地区/城市所属国家名称
    public var fxLink: String       //该地区的天气预报网页链接，便于嵌入你的网站或应用
    public var id: String           //地区/城市ID
    public var isDst: String        //地区/城市是否当前处于夏令时 1 表示当前处于夏令时 0 表示当前不是夏令时
    public var lat: String          //地区/城市纬度
    public var lon: String          //地区/城市经度
    public var name: String         //地区/城市名称
    public var rank: String         //地区评分
    public var type: String         //地区/城市的属性
    public var tz: String           //地区/城市所在时区
    public var utcOffset: String    //地区/城市目前与UTC时间偏移的小时数，参考详细说明
}

public struct QWeatherRefer: Codable {
    public var license: [String]    //数据许可或版权声明，可能为空
    public var sources: [String]    //原始数据来源，或数据源说明，可能为空
}
