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
//              .fontWeight(.medium)
            Text("\(formattedText.last ?? "")")
              .heading5()
//              .fontWeight(.medium)
          }
          .foregroundStyle(.black)
          
            .multilineTextAlignment(.center)
            .frame(maxHeight: 65)
            .padding(.vertical)
            .padding(.horizontal,30)
            .background(UnevenRoundedRectangle(topLeadingRadius: 20,bottomLeadingRadius: 20).foregroundStyle(.ongoingEventDate))
          
        }
        VStack(alignment:.leading,spacing: 12 ) {
          Text(event.name)
            .heading5()
            .lineLimit(1)
            .truncationMode(.tail)
            .foregroundStyle(Color.black)
          HStack {
            Text(event.location)
            .lineLimit(1)
            .truncationMode(.tail)
              .heading6()
              .foregroundStyle(Color.black.opacity(0.65))
            Spacer()
              SmallParticipantView(event: event, participantCount: 4)
                
          }
        }
        .frame(maxHeight: 65)
        .padding(.vertical)
        .padding(.horizontal,6)
        .background(UnevenRoundedRectangle(bottomTrailingRadius: 20, topTrailingRadius: 20).foregroundStyle(.ongoingEventName))
    
      }
      .frame(maxWidth: .infinity)
      .fixedSize(horizontal: false, vertical: true)
      
    }
}

#Preview {
  CurrentEventRow(event: EventMock.instance.eventA)
    .padding()
}
