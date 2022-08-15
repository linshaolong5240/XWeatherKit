//
//  XWWeatherMinutely.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/6/1.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct XWWeatherMinutely: XWWeatherData {
    public var description: String? = nil
    public var precipitation: [Double] = []
    public var probability: [Double] = []
    
    public init() { }
    
    public init(description: String? = nil, precipitation: [Double] = [], probability: [Double] = []) {
        self.description = description
        self.precipitation = precipitation
        self.probability = probability
    }
}

extension XWWeatherMinutely {
    public init(_ model: CYWeatherMinutely) {
        self.description = model.description
        self.precipitation = model.precipitation_2h
        self.probability = model.probability
    }
}
