//
//  ParticipantView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/10/2024.
//

import SwiftUI
import Kingfisher

struct ParticipantView: View {
    let event : EventModel
    var body: some View {
        HStack {
            HStack(spacing:-12) {
                if let eventParticipants = event.participants {
                    ForEach(eventParticipants.prefix(5),id: \.userid){ event in
                        KFImage(URL(string: event.profileImageUrl ?? ""))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:28,height: 28)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(
                                        Color.black,
                                        lineWidth: 1
                                    )
                            )
                        
                        
                    }
                    
                    
                 
                }
            }
            if let eventParticipants = event.participants {
                Text("\(eventParticipants.count) / \(event.maxParticipants)")
                    .font(CustomFont.eventBodyStyle)
            }
    }
       
      

    }
}

#Preview {
    ParticipantView(event: EventMock.instance.eventA)
}



