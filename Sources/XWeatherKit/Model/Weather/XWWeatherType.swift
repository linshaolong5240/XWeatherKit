//
//  XWWeatherType.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/8.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import SwiftUI

public enum XWWeatherType: String, CaseIterable, XWWeatherData {
    case clear_day, clear_night                 //晴
    case couldy, cloudy_day, cloud_night        //多云
    case overcast                               //阴
    case rain_showers_day, rain_showers_night   //阵雨
    case light_rain                             //小雨
    case moderate_rain                          //中雨
    case heavy_rain                             //大雨
    case torrential_rain                        //暴雨
    case light_snow                             //小雪
    case moderate_snow                          //中雪
    case heavy_snow                             //大雪
    case blizzards                              //暴雪
    case sleet                                  //雨夹雪
    case hail                                   //冰雹
    case thunderbolt, thunderbolt_day, thunderbolt_night//雷电
    case thundershowers                         //雷阵雨
    case fog                                    //雾
    case haze                                   //霾
    case dust                                   //尘
    case windy                                  //风
    case tornado                                //龙卷风
    case tropicalstorm                          //热带风暴
    case hurricane                              //飓风
    case unknow                                 //未知
}

extension XWWeatherType {
    public var name: String {
        switch self {
        case .clear_day, .clear_night:
            return "Clear"
        case .couldy, .cloudy_day, .cloud_night:
            return "Couldy"
        case .overcast:
            return "Overcast"
        case .rain_showers_day, .rain_showers_night:
            return "Rain showers"
        case .light_rain:
            return "Drizzle"
        case .moderate_rain:
            return "Rain"
        case .heavy_rain:
            return "Heavy rain"
        case .torrential_rain:
            return "Torrential rain"
        case .light_snow:
            return "Light snow"
        case .moderate_snow:
            return "Snow"
        case .heavy_snow:
            return "Heavy snow"
        case .blizzards:
            return "Blizzards"
        case .sleet:
            return "Sleet"
        case .hail:
            return "Hail"
        case .thunderbolt, .thunderbolt_day, .thunderbolt_night:
            return "Thunderbolt"
        case .thundershowers:
            return "Thundershowers"
        case .fog:
            return "Fog"
        case .haze:
            return "Haze"
        case .dust:
            return "Dust"
        case .windy:
            return "Windy"
        case .tornado:
            return "Tornado"
        case .tropicalstorm:
            return "Tropicalstorm"
        case .hurricane:
            return "Hurricane"
        case .unknow:
            return "Unknow"
        }
    }
    
    public var systemImageName: String {
        switch self {
        case .clear_day:
            return "sun.max"
        case .clear_night:
            return "moon"
        case .couldy:
            return "cloud"
        case .cloudy_day:
            return "cloud.sun"
        case .cloud_night:
            return "cloud.moon"
        case .overcast:
            return "smoke"
        case .rain_showers_day:
            return "cloud.sun.rain"
        case .rain_showers_night:
            return "cloud.moon.rain"
        case .light_rain:
            return "cloud.drizzle"
        case .moderate_rain:
            return "cloud.rain"
        case .heavy_rain:
            return "cloud.heavyrain"
        case .torrential_rain:
            return "cloud.heavyrain"
        case .light_snow:
            return "cloud.snow"
        case .moderate_snow:
            return "cloud.snow"
        case .heavy_snow:
            return "cloud.snow"
        case .blizzards:
            return "cloud.snow"
        case .sleet:
            return "cloud.sleet"
        case .hail:
            return "cloud.hail"
        case .thunderbolt:
            return "cloud.bolt"
        case .thunderbolt_day:
            return "cloud.sun.bolt"
        case .thunderbolt_night:
            return "cloud.moon.rain"
        case .thundershowers:
            return "cloud.bolt.rain"
        case .fog:
            return "cloud.fog"
        case .haze:
            return "sun.haze"
        case .dust:
            return "sun.dust"
        case .windy:
            return "wind"
        case .tornado:
            return "tornado"
        case .tropicalstorm:
            return "tropicalstorm"
        case .hurricane:
            return "hurricane"
        case .unknow:
            return "questionmark"
        }
    }
}

#if DEBUG
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct XWWeatherType_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(XWWeatherType.allCases, id: \.self) { item in
                    HStack {
                        if #available(iOS 14.0, macOS 11.0, *) {
                            Image(systemName: item.systemImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            //                            .symbolVariant(.fill)
                                .frame(width: 50, height: 50)
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text(item.name)
                            Text("imageName: \(item.systemImageName)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
    }
}
#endif

extension XWWeatherType {
    public init(cywSkycon: String) {
        switch cywSkycon {
        case "CLEAR_DAY":
            self = .clear_day
        case "CLEAR_NIGHT":
            self = .clear_night
        case "PARTLY_CLOUDY_DAY":
            self = .cloudy_day
        case "PARTLY_CLOUDY_NIGHT":
            self = .clear_night
        case "CLOUDY":
            self = .couldy
        case "LIGHT_HAZE", "MODERATE_HAZE", "HEAVY_HAZE":
            self = .haze
        case "LIGHT_RAIN":
            self = .light_rain
        case "MODERATE_RAIN":
            self = .moderate_rain
        case "HEAVY_RAIN":
            self = .heavy_rain
        case "STORM_RAIN":
            self = .torrential_rain
        case "FOG":
            self = .fog
        case "LIGHT_SNOW":
            self = .light_snow
        case "MODERATE_SNOW":
            self = .moderate_snow
        case "HEAVY_SNOW":
            self = .heavy_snow
        case "STORM_SNOW":
            self = .blizzards
        case "DUST":
            self = .dust
        case "SAND":
            self = .dust
        case "WIND":
            self = .windy
        default:
            self = .unknow
        }
    }
}

extension XWWeatherType {
    public init(qwIconCode: String) {
        switch qwIconCode {
        case "100": self = .clear_day
        case "101": self = .cloudy_day
        case "102": self = .cloudy_day
        case "103": self = .cloudy_day
        case "104": self = .overcast
            
        case "150": self = .clear_night
        case "151": self = .cloud_night
        case "152": self = .cloud_night
        case "153": self = .cloud_night
        case "154": self = .overcast
            
        case "300": self = .rain_showers_day
        case "301": self = .rain_showers_day
        case "302": self = .thundershowers
        case "303": self = .thundershowers
        case "304": self = .thundershowers
            
        case "305": self = .light_rain
        case "306": self = .moderate_rain
        case "307": self = .heavy_rain
        case "308": self = .heavy_rain
        case "309": self = .light_rain
        case "310": self = .heavy_rain
        case "311": self = .heavy_rain
        case "312": self = .heavy_rain
        case "313": self = .hail
        case "314": self = .light_rain
        case "315": self = .moderate_rain
        case "316": self = .heavy_rain
        case "317": self = .heavy_rain
        case "318": self = .heavy_rain
            
        case "350": self = .rain_showers_night
        case "351": self = .rain_showers_night

        case "399": self = .moderate_rain
        
        case "400": self = .light_snow
        case "401": self = .moderate_snow
        case "402": self = .heavy_snow
        case "403": self = .blizzards
        case "404": self = .sleet
        case "405": self = .sleet
        case "406": self = .sleet
        case "407": self = .light_snow
        case "408": self = .light_snow
        case "409": self = .moderate_snow
        case "410": self = .heavy_snow
        case "456": self = .sleet
        case "457": self = .light_snow
        case "499": self = .light_snow
            
        case "500": self = .fog
        case "501": self = .fog
        case "502": self = .haze
            
        case "503": self = .dust
        case "504": self = .dust
        case "507": self = .dust
        case "508": self = .dust
        case "509": self = .fog
        case "510": self = .fog
        case "511": self = .fog
        case "512": self = .fog
        case "513": self = .fog
        case "514": self = .fog
        case "515": self = .fog

        default:  self = .unknow
        }
    }
}

//qweather
//100    晴    ✅    ❌
//101    多云    ✅    ❌
//102    少云    ✅    ❌
//103    晴间多云    ✅    ❌
//104    阴    ✅    ✅
//150    晴    ❌    ✅
//151    多云    ❌    ✅
//152    少云    ❌    ✅
//153    晴间多云    ❌    ✅
//154    阴    ✅    ✅
//300    阵雨    ✅    ❌
//301    强阵雨    ✅    ❌
//302    雷阵雨    ✅    ✅
//303    强雷阵雨    ✅    ✅
//304    雷阵雨伴有冰雹    ✅    ✅
//305    小雨    ✅    ✅
//306    中雨    ✅    ✅
//307    大雨    ✅    ✅
//308    极端降雨    ✅    ✅
//309    毛毛雨/细雨    ✅    ✅
//310    暴雨    ✅    ✅
//311    大暴雨    ✅    ✅
//312    特大暴雨    ✅    ✅
//313    冻雨    ✅    ✅
//314    小到中雨    ✅    ✅
//315    中到大雨    ✅    ✅
//316    大到暴雨    ✅    ✅
//317    暴雨到大暴雨    ✅    ✅
//318    大暴雨到特大暴雨    ✅    ✅
//350    阵雨    ❌    ✅
//351    强阵雨    ❌    ✅
//399    雨    ✅    ✅
//400    小雪    ✅    ✅
//401    中雪    ✅    ✅
//402    大雪    ✅    ✅
//403    暴雪    ✅    ✅
//404    雨夹雪    ✅    ✅
//405    雨雪天气    ✅    ✅
//406    阵雨夹雪    ✅    ❌
//407    阵雪    ✅    ❌
//408    小到中雪    ✅    ✅
//409    中到大雪    ✅    ✅
//410    大到暴雪    ✅    ✅
//456    阵雨夹雪    ❌    ✅
//457    阵雪    ❌    ✅
//499    雪    ✅    ✅
//500    薄雾    ✅    ✅
//501    雾    ✅    ✅
//502    霾    ✅    ✅
//503    扬沙    ✅    ✅
//504    浮尘    ✅    ✅
//507    沙尘暴    ✅    ✅
//508    强沙尘暴    ✅    ✅
//509    浓雾    ✅    ✅
//510    强浓雾    ✅    ✅
//511    中度霾    ✅    ✅
//512    重度霾    ✅    ✅
//513    严重霾    ✅    ✅
//514    大雾    ✅    ✅
//515    特强浓雾    ✅    ✅
//800    新月    ✅    ✅
//801    蛾眉月    ✅    ✅
//802    上弦月    ✅    ✅
//803    盈凸月    ✅    ✅
//804    满月    ✅    ✅
//805    亏凸月    ✅    ✅
//806    下弦月    ✅    ✅
//807    残月    ✅    ✅
//900    热    ✅    ✅
//901    冷    ✅    ✅
//999    未知    ✅    ✅



//彩云
//晴（白天）    CLEAR_DAY    cloudrate < 0.2
//晴（夜间）    CLEAR_NIGHT    cloudrate < 0.2
//多云（白天）    PARTLY_CLOUDY_DAY    0.8 >= cloudrate > 0.2
//多云（夜间）    PARTLY_CLOUDY_NIGHT    0.8 >= cloudrate > 0.2
//阴    CLOUDY    cloudrate > 0.8
//轻度雾霾    LIGHT_HAZE    PM2.5 100~150
//中度雾霾    MODERATE_HAZE    PM2.5 150~200
//重度雾霾    HEAVY_HAZE    PM2.5 > 200
//小雨    LIGHT_RAIN    见 降水强度
//中雨    MODERATE_RAIN    见 降水强度
//大雨    HEAVY_RAIN    见 降水强度
//暴雨    STORM_RAIN    见 降水强度
//雾    FOG    能见度低，湿度高，风速低，温度低
//小雪    LIGHT_SNOW    见 降水强度
//中雪    MODERATE_SNOW    见 降水强度
//大雪    HEAVY_SNOW    见 降水强度
//暴雪    STORM_SNOW    见 降水强度
//浮尘    DUST    AQI > 150, PM10 > 150，湿度 < 30%，风速 < 6 m/s
//沙尘    SAND    AQI > 150, PM10> 150，湿度 < 30%，风速 > 6 m/s
//大风    WIND
