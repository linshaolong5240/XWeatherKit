//
//  XWWindInfo.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import SwiftUI

public struct XWWindInfo: XWWeatherData {
    public var direct: XWWindDirect
    public var level: Int?             //风力等级
    public var speed: Double?          //风速，公里/小时
    
    public init(direct: XWWindDirect, level: Int?, speed: Double?) {
        self.direct = direct
        self.level = level
        self.speed = speed
    }
}

#if DEBUG
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct XWWindInfo_Previews: PreviewProvider {
    static var previews: some View {
        let windy = XWWindInfo(direct: .init(angle: 22.5), level: 2, speed: 2)
        Text(windy.direct.description)
    }
}
#endif
