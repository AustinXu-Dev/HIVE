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
          VStack(alignment: .center, spacing: 6) {
            Text("\(formattedText.first ?? "")")
              .heading3()
            Text("\(formattedText.last ?? "")")
              .heading5()
          }
          .foregroundStyle(.black)
          
            .multilineTextAlignment(.center)
            .frame(maxHeight: 40)
            .padding(.vertical)
            .padding(.horizontal)
            .background(UnevenRoundedRectangle(topLeadingRadius: 20,bottomLeadingRadius: 20).foregroundStyle(.ongoingEventDate))
          
        }
        VStack(alignment:.leading,spacing: 6) {
          Text(event.name)
            .heading5()
            .foregroundStyle(Color.black)
          HStack {
            Text(event.location)
              .heading6()
              .foregroundStyle(Color.black.opacity(0.65))
            Spacer()
            ParticipantView(event: event)
              .fixedSize(horizontal: true, vertical: false)
          }
        }
        .frame(maxHeight: 40)
        .padding(.vertical)
        .padding(.horizontal)
        .background(UnevenRoundedRectangle(bottomTrailingRadius: 20, topTrailingRadius: 20).foregroundStyle(.ongoingEventName))
    
      }
      .frame(maxWidth: .infinity)
      
    }
}

#Preview {
  CurrentEventRow(event: EventMock.instance.eventA)
    .padding()
}
