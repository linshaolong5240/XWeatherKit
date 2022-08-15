//
//  XWWeatherLocation.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/4/30.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import CoreLocation
import Contacts.CNPostalAddress

public struct XWWeatherLocation: XWWeatherData, Identifiable, Equatable {
    public var id: String { "\(longitude),\(latitude)" }
    public var latitude: String
    public var longitude: String
    public var name: String?
    public var updateDate: Date?
    
    public func isUpdateValid(timeInterval: TimeInterval) -> Bool {
        if updateDate == nil {
            return true
        }
        
        if let date = updateDate, Date().timeIntervalSince1970 - date.timeIntervalSince1970 < timeInterval {
            #if DEBUG
            print("location refresh abort, TimeInterval: \(timeInterval)")
            #endif
            return false
        } else {
            return true
        }

    }

    public init(latitude: String, longitude: String, name: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}

extension XWWeatherLocation {
    public init(location: QWeatherLocation) {
        self.init(latitude: location.lat, longitude: location.lon, name: location.name)
    }
    
    public init(placemark: CLPlacemark) {
        self.longitude = "\(placemark.location?.coordinate.longitude ?? .zero)"
        self.latitude = "\(placemark.location?.coordinate.latitude ?? .zero)"
        self.name = placemark.locality
    }
}
