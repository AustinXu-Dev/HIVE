import Kingfisher
import SwiftUI

struct SmallParticipantView: View {
    let event : EventModel
    let participantCount: Int
    var body: some View {
        HStack {
            HStack(spacing:-4) {
                if let eventParticipants = event.participants {
                    ForEach(eventParticipants.prefix(participantCount),id: \._id){ user in
                        KFImage(URL(string: user.profileImageUrl ?? ""))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:16,height: 16)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.top, .bottom]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                            
                                        ),
                                        lineWidth: 1
                                    )
                            )
                        
                        
                    }
                    
                    
                 
                }
            }
            if let eventParticipants = event.participants {
                Text("\(eventParticipants.count)/\(event.maxParticipants)")
                  //  .light7()
                    .heading7()
                    .foregroundStyle(Color.black.opacity(0.65))

            }
    }

    }
}
#Preview {
    SmallParticipantView(event: EventMock.instance.eventA, participantCount: 4)
}
