//
//  TextEditorWithPlaceholder.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/28.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty {
                Text("Name")
                    .opacity(0.6)
                    .font(.title2)
            }
            TextEditor(text: $text)
                .opacity(text.isEmpty ? 0.85 : 1)
                .multilineTextAlignment(.center)
                .limitInputLength(value: $text, length: 10)
                .focused($isFocused)
        }
        .frame(minWidth: 150)
    }
}

//#Preview{
//    TextEditorWithPlaceholder(text: .constant("name"))
//}
