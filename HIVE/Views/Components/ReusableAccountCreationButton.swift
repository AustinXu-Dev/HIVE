//
//  ReusableAccountCreationButton.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 08/11/2024.
//

import SwiftUI

struct ReusableAccountCreationButton: View {
    var body: some View {
      Text("Create an Account")
          .foregroundStyle(.white)
          .padding(10)
          .background(Color.black)
          .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    ReusableAccountCreationButton()
}
