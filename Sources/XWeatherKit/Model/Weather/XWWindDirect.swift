//
//  XWWindDirect.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

public enum XWWindDirect: XWWeatherData, CustomStringConvertible {
    case north
    case north_north_east
    case north_east
    case east_north_east
    case east
    case east_south_east
    case south_east
    case south_south_east
    case south
    case south_south_west
    case south_west
    case west_south_west
    case west
    case west_north_west
    case north_west
    case north_north_west
    
    public init(angle: Double) {
        switch angle {
        case 348.75...360, 0...11.25:       self = .north
        case 11.25...33.75:                 self = .north_north_east
        case 33.75...56.25:                 self = .north_east
        case 56.25...78.75:                 self = .east_north_east
        case 78.75...101.25:                self = .east
        case 101.25...123.75:               self = .east_south_east
        case 123.75...146.25:               self = .south_east
        case 146.25...168.75:               self = .south_south_east
        case 168.75...191.25:               self = .south
        case 191.25...213.75:               self = .south_south_west
        case 213.75...236.25:               self = .south_west
        case 236.25...258.75:               self = .west_south_west
        case 258.75...281.25:               self = .west
        case 281.25...303.75:               self = .west_north_west
        case 303.75...326.25:               self = .north_west
        case 326.25...348.75:               self = .north_north_west
        default:                            self = .south
        }
    }
    
    public var description: String {
        switch self {
        case .north:
            return "North"
        case .north_north_east:
            return "North North East"
        case .north_east:
            return "North East"
        case .east_north_east:
            return "East North East"
        case .east:
            return "East"
        case .east_south_east:
            return "East South East"
        case .south_east:
            return "South East"
        case .south_south_east:
            return "South South East"
        case .south:
            return "South"
        case .south_south_west:
            return "South South West"
        case .south_west:
            return "South West"
        case .west_south_west:
            return "West South West"
        case .west:
            return "West"
        case .west_north_west:
            return "West North West"
        case .north_west:
            return "North West"
        case .north_north_west:
            return "North North West"
        }
    }
}
