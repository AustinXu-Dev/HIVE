//
//  Color+Extension.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import Foundation
import SwiftUI

extension Color {
    static func applyGradientColor(startPoint: UnitPoint, endPoint: UnitPoint) -> LinearGradient {
        let gradientColors = [Color("topColor"),Color("bottomColor")]
        
        return LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: startPoint, endPoint: endPoint)
    }
}

