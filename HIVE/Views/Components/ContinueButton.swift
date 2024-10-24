//
//  ContinueButton.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import SwiftUI

struct ContinueButton: View {
    @Binding var currentStep: Int
    var action:() -> Void
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 250, height: 50)
            .overlay {
                Text("Continue")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .font(.title3)
            }
            .onTapGesture {
                action()
            }
    }
}

#Preview {
    ContinueButton(currentStep: .constant(0), action: {})
}
