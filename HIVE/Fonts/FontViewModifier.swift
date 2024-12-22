//
//  FontViewModifier.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 21/12/24.
//

import Foundation
import SwiftUI

struct LatoFont{
    static let boldFont = "Lato-Bold"
    static let regularFont = "Lato-Regular"
    static let lightFont = "Lato-Light"
}

struct CustomFontModifier: ViewModifier {
    var font: Font

    func body(content: Content) -> some View {
        content
            .font(font)
    }
}

extension View{
    func heading1() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 36)))
    }
    
    func heading2() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 32)))
    }
    
    func heading3() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 30)))
    }
    
    func heading4() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 24)))
    }
    
    func heading5() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 20)))
    }
  
  func heading5half() -> some View{
      self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 18)))
  }
  
    
    func heading6() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 16)))
    }
    
    func heading7() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 14)))
    }
    
    func heading8() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 13)))
    }
    
    func heading9() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.boldFont, size: 10)))
    }
    
    func body1() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.regularFont, size: 36)))
    }
    
    func body2() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.regularFont, size: 30)))
    }
    
    func body3() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.regularFont, size: 26)))
    }
    
    func body4() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.regularFont, size: 20)))
    }
    
    func body5() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.regularFont, size: 18)))
    }
    
    func body6() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.regularFont, size: 16)))
    }
    
    func body7() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.regularFont, size: 15)))
    }
    
    func body8() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.regularFont, size: 12)))
    }
    
    func light1() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.lightFont, size: 24)))
    }
    
    func light2() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.lightFont, size: 18)))
    }
    
    func light3() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.lightFont, size: 16)))
    }
    
    func light4() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.lightFont, size: 15)))
    }
    
    func light7() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.lightFont, size: 14)))
    }
    
    func light5() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.lightFont, size: 13)))
    }
    
    func light6() -> some View{
        self.modifier(CustomFontModifier(font: .custom(LatoFont.lightFont, size: 12)))
    }
}
