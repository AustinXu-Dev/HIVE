//
//  EventRow.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 30/11/2024.
//

import SwiftUI
import Kingfisher

struct EventRow: View {
  let event: EventHistoryModel
    var body: some View {
      HStack {
        if let eventImageUrl = event.eventImageUrl {
          KFImage(URL(string: eventImageUrl))
            .resizable()
            .frame(width: 75,height: 75)
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        VStack(alignment:.leading,spacing:12){
          Text(event.name ?? "")
            .font(CustomFont.eventRowEventTitle)
          HStack {
//            if let eventDate = Date.stringToDate(event.startDate ?? ""){
//              Text(eventDate.toDayMonthYearString())
//                .font(CustomFont.eventRowEventDate)
//            }
            Text("May 28, 2024")
                .font(CustomFont.eventRowEventDate)
            Spacer()
          //  ParticipantView(event: event)
          }
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical,8)
      .padding(.horizontal,12)
      .background {
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color.black.opacity(0.6),lineWidth:1)
          .foregroundStyle(Color.gray.opacity(0.35))
      }
    }
}

//#Preview {
//  EventRow(event: EventMock.instance.eventA)
//    .padding(.horizontal)
//}
