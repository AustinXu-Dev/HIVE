//
//  ProgressView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import SwiftUI

struct ProgressView: View {
    var steps : Int
    @Binding var currentStep : Int
    
    var body: some View {
        HStack{
            ForEach(0..<steps, id: \.self){ item in
                GeometryReader{ geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .frame(width: geo.size.width, height: 5)
                            .foregroundStyle(.gray.opacity(0.3))
                        Capsule()
                            .frame(width: currentStep >= item ? geo.size.width : 0, height: 5)
                            .animation(.easeInOut, value: currentStep)
                    }
                }
            }
        }.frame(height: 6)
    }
}

#Preview {
    ProgressView(steps: 5, currentStep: .constant(0))
}
