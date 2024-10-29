//
//  View+Extension.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/29.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}