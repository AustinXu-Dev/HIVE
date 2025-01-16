//
//  myTestView.swift
//  HIVE
//
//  Created by Patrick on 16/1/2568 BE.
//

import SwiftUI

struct myTestView: View {
    var body: some View {
        Image("human1")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
    }
}

#Preview {
    myTestView()
}
