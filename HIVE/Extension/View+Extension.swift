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
    
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
    
    
    //Fonts
    func applySecondaryHeadingFont() -> some View {
           self
            .font(.custom(Theme.SecondaryFont.headingFontStyle, size: Theme.SecondaryFont.headingFontSize))
       }
    
    func applySecondaryBodyFont() -> some View {
        self
            .font(.custom(Theme.SecondaryFont.bodyFontStyle, size: Theme.SecondaryFont.bodyFontSize))
    }
    
    
    
    
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
