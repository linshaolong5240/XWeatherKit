//
//  CYWeatherAction.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/30.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import struct Alamofire.HTTPMethod

public struct CYWeatherParameters: XWeatherServerParameters {
    public enum Unit: String, XWeatherServerParameters {
        case imperial = "imperial"      //英制
        case metric = "metric"          //默认公制
        case metric_v1 = "metric:v1"    //公制 V1
        case metric_v2 = "metric:v2"    //公制 V2
        case si = "SI"                  //科学单位体系
    }
    
    public var token: String            //caiyun token
    public var longitude: String        //经度
    public var latitude: String         //纬度
    
    public var alert: String? = nil     //控制返回预警数据
    public var hourlysteps: Int? = nil  //控制返回多少小时的数据
    public var dailysteps: Int? = nil   //控制返回多少天的数据
    //https://docs.caiyunapp.com/docs/tables/lang
    public var lang: String? = nil      //语言
    //https://docs.caiyunapp.com/docs/tables/unit
    public var unit: String? = nil      //数据的单位
    
    public init(token: String, longitude: String, latitude: String, alert: Bool? = nil, hourlysteps: Int? = nil, dailysteps: Int? = nil, lang: String? = nil, unit: Unit? = nil) {
        self.token = token
        self.longitude = longitude
        self.latitude = latitude
        self.alert = alert?.description
        self.hourlysteps = hourlysteps
        self.dailysteps = dailysteps
        self.lang = lang
        self.unit = unit?.rawValue
    }
}

public struct CYWratherEmptyParameters: Codable { }

public protocol CYWeatherAction: XWeatherServerAction  { }

extension CYWeatherAction {
    var cyweatherHost: String { "https://api.caiyunapp.com/v2.6" }
}
