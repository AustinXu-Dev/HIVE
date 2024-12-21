//
//  BlackButton.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 10/12/2567 BE.
//

import SwiftUI

struct BlackButton: View {
    
    var text: String
    @Binding var color: Color
    var action:() -> Void
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 250, height: 50)
            .foregroundStyle(color)
            .overlay {
                Text(text)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .heading4()
            }
            .onTapGesture {
                action()
            }
    }
}
