//
//  EnvironmentKey.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 07/11/2024.
//

import Foundation
import SwiftUI

private struct IsGuestKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isGuest: Bool {
        get { self[IsGuestKey.self] }
        set { self[IsGuestKey.self] = newValue }
    }
}
