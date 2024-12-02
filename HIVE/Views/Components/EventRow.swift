//
//  EventRow.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 30/11/2024.
//

import SwiftUI
import Kingfisher

struct EventRow: View {
  let event: EventModel
    var body: some View {
      HStack {
        KFImage(URL(string: event.eventImageUrl))
            .resizable()
            .frame(width: 75,height: 75)
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        
        VStack(alignment:.leading,spacing:12){
          Text(event.name)
            .font(CustomFont.eventRowEventTitle)
          HStack {
            if let eventDate = Date.stringToDate(event.startDate){
              Text(eventDate.toDayMonthYearString())
                .font(CustomFont.eventRowEventDate)
            }
            
            Spacer()
           
            ParticipantView(event: event)
              .fixedSize(horizontal: true, vertical: false)
          }
        }
        
      }
      .padding(.vertical,8)
      .padding(.horizontal,12)
      .frame(maxWidth: .infinity)
      .background {
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color.black.opacity(0.6),lineWidth:1)
          .foregroundStyle(Color.gray.opacity(0.35))
      }
     
    }
}


#Preview {
  EventRow(event: EventMock.instance.eventA)
    .padding(.horizontal)
}
