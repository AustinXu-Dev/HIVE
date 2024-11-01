//
//  TextFieldLimitedModifier.swift
//  HIVE
//
//  Created by Austin Xu on 2024/11/1.
//

import SwiftUI

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}
