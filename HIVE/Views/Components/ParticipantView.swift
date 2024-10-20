//
//  ParticipantView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/10/2024.
//

import SwiftUI

struct ParticipantView: View {
    let event = EventMock.instance.eventA
    var body: some View {
        HStack {
            
        
        HStack(spacing:-12) {
            
            ForEach(event.participants.prefix(5),id: \._id){ event in
                Image(event.profileImageUrl ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:28,height: 28)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [   Color("topColor"), Color("bottomColor")  ]),
                                    
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
                
                
                
                
                
            }
            
            
            
        }
            Text("\(event.participants.count) / \(event.maxParticipants)")
                
            
    }
        
    }
}

#Preview {
    ParticipantView()
}



