//
//  WeatherAQI.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/31.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
fileprivate extension Color {
    static let aqiSerious: Color =      Color(#colorLiteral(red: 0.6392156863, green: 0.09803921569, blue: 0.4588235294, alpha: 1))
    static let aqiSevere: Color =       Color(#colorLiteral(red: 0.5607843137, green: 0.1333333333, blue: 0.1333333333, alpha: 1))
    static let aqiModerate: Color =     Color(#colorLiteral(red: 0.8666666667, green: 0.3450980392, blue: 0.3019607843, alpha: 1))
    static let aqiMild: Color =         Color(#colorLiteral(red: 0.9647058824, green: 0.6, blue: 0.1960784314, alpha: 1))
    static let aqiGood: Color =         Color(#colorLiteral(red: 0.9647058824, green: 0.7764705882, blue: 0.1960784314, alpha: 1))
    static let aqiExcellent: Color =    Color(#colorLiteral(red: 0.3490196078, green: 0.8431372549, blue: 0.5568627451, alpha: 1))
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension XWWeatherAQIType {
    public var foregroundColor: Color {
        switch level {
        case 0:         return .aqiExcellent
        case 1:         return .aqiGood
        case 2:         return .aqiMild
        case 3:         return .aqiModerate
        case 4:         return .aqiSevere
        case 5:         return .aqiSerious
        case 6:         return .aqiSerious
        default:        return .aqiExcellent
        }
    }
}

public enum XWWeatherAQIType: XWWeatherData {
    case aqi(value: Double)
    case co(value: Double)
    case no2(value: Double)
    case o3(value: Double)
    case pm10(value: Double)
    case pm25(value: Double)
    case so2(value: Double)
    
    public var name: String {
        switch self {
        case .aqi:
            return "AQI"
        case .co:
            return "CO"
        case .no2:
            return "NO2"
        case .o3:
            return "O3"
        case .pm10:
            return "PM10"
        case .pm25:
            return "PM2.5"
        case .so2:
            return "SO2"
        }
    }
    
    public var levelDescription: String {
        switch self {
        default:
            switch level {
            case 0: return "AQI_Excellent"
            case 1: return "AQI_Good"
            case 2: return "AQI_Mild"
            case 3: return "AQI_Moderate"
            case 4: return "AQI_Severe"
            case 5: return "AQI_Serious"
            case 6: return "AQI_Serious"
            default: return "AQI_Excellent"
            }
        }
    }
    
    public var levelString: String { String(value) + " " + levelDescription }
    
    public var level: Int {
        switch self {
        case .aqi(let value):
            switch value {
            case 0...50:        return 0
            case 50...100:      return 1
            case 100...150:     return 2
            case 150...200:     return 3
            case 200...300:     return 4
            default:            return 5
            }
        case .co(let value):
            switch value {
            case 0...5:         return 0
            case 5...10:        return 1
            case 10...35:       return 2
            case 35...60:       return 3
            case 60...90:       return 4
            case 90...150:      return 5
            default:            return 0
            }
        case .no2(let value):
            switch value {
            case 0...100:       return 0
            case 100...200:     return 1
            case 200...700:     return 2
            case 700...1200:    return 3
            case 1200...2340:   return 4
            case 2340...:       return 5
            default:            return 0
            }
        case .o3(let value):
            switch value {
            case 0...160:       return 0
            case 160...200:     return 1
            case 200...300:     return 2
            case 300...400:     return 3
            case 400...800:     return 4
            case 800...:        return 5
            default:            return 0
            }
        case .pm10(let value):
            switch value {
            case 0...50:        return 0
            case 50...150:      return 1
            case 150...250:     return 2
            case 250...350:     return 3
            case 350...420:     return 4
            case 420...600:     return 5
            case 600...:        return 6
            default:            return 0
            }
        case .pm25(let value):
            switch value {
            case 0...35:        return 0
            case 35...75:       return 1
            case 75...115:      return 2
            case 115...150:     return 3
            case 150...250:     return 4
            case 259...500:     return 5
            case 500...:        return 6
            default:            return 0
            }
        case .so2(let value):
            switch value {
            case 0...150:       return 0
            case 150...500:     return 1
            case 500...650:     return 2
            case 650...800:     return 3
            case 800...1600:    return 4
            case 1600...:       return 5
            default:            return 0
            }
        }
    }
    
    public var value: Int {
        switch self {
        case .aqi(let value):       return Int(value.rounded())
        case .co(let value):        return Int(value.rounded())
        case .no2(let value):       return Int(value.rounded())
        case .o3(let value):        return Int(value.rounded())
        case .pm10(let value):      return Int(value.rounded())
        case .pm25(let value):      return Int(value.rounded())
        case .so2(let value):       return Int(value.rounded())
        }
    }
    
    public var max: Int {
        switch self {
        case .aqi:      return 300
        case .co:       return 150
        case .no2:      return 2340
        case .o3:       return 800
        case .pm10:     return 600
        case .pm25:     return 500
        case .so2:      return 1600
        }
    }
}
