//
//  XWTemperature.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/7/26.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public struct XWTemperature: XWWeatherData {
    public enum Unit: XWWeatherData {
        case celsius
        case fahrenheit
        
        public var symbol: String {
            switch self {
            case .celsius:
                return "°C"
            case .fahrenheit:
                return "℉"
            }
        }
    }
    
    var celsius: Double
    var fahrenheit: Double
    
    public init(unit: Unit, value: Double) {
        switch unit {
        case .celsius:
            self.celsius = value
            self.fahrenheit = 32 + 1.8 * value
        case .fahrenheit:
            self.celsius = (value - 32) / 1.8
            self.fahrenheit = value
        }
    }
}
