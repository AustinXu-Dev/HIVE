//
//  CurrentEventRow.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 11/12/2024.
//

import SwiftUI

struct CurrentEventRow: View {
  let event: EventModel
    var body: some View {
      HStack(spacing:0) {
        if let eventDate = Date.stringToDate(event.startDate) {
          let formattedText = eventDate.toDayMonthString().split(separator: " ")
          VStack(alignment: .center, spacing: 12) {
            Text("\(formattedText.first ?? "")")
            Text("\(formattedText.last ?? "")")
          }
            .fontWeight(.semibold)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .frame(maxHeight: 60)
            .padding(.vertical)
            .padding(.horizontal)
            .background(UnevenRoundedRectangle(topLeadingRadius: 8,bottomLeadingRadius: 8).foregroundStyle(Color.gray.opacity(0.5)))
          
        }
        VStack(alignment:.leading,spacing: 12) {
          Text(event.name)
            .bold()
            .font(.subheadline)
          HStack {
            Text(event.location)
              .font(.caption)
              .foregroundStyle(Color.black.opacity(0.65))
            Spacer()
            ParticipantView(event: event)
              .fixedSize(horizontal: true, vertical: false)
          }
        }
        .frame(maxHeight: 60)
        .padding(.vertical)
        .padding(.horizontal)
        .background(UnevenRoundedRectangle(bottomTrailingRadius: 8, topTrailingRadius: 8).foregroundStyle(Color.gray.opacity(0.85)))
    
      }
      .frame(maxWidth: .infinity)
    
    }
}

#Preview {
  CurrentEventRow(event: EventMock.instance.eventA)
    .padding()
}
