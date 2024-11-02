//
//  SeeWhoGoingView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 19/10/2567 BE.
//

import SwiftUI
import Kingfisher


struct EventAttendeeView: View {
    let event : EventModel
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl

    var body: some View {
        VStack {
            HStack {
//                Button(action: {
//                }) {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                        Text("Back")
//                    }
//                    .foregroundColor(.black)
//                }

//                Spacer()


               
            }

            Divider()
            
            List(event.participants ?? [],id: \.userid) { user in
                HStack {
                    KFImage(URL(string: user.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(user.name ?? "Unknown")
                            .font(.headline)
                        
                        Text(user.bio ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                  
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxWidth:.infinity)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.000001))
                .onTapGesture {
                    appCoordinator.push(.participantProfile(named: user))
                }
              
            }
            .listStyle(PlainListStyle())
            .scrollIndicators(.hidden)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Text("Back")
                    .onTapGesture {
                        appCoordinator.pop()
                    }
            }
            ToolbarItem(placement: .principal) {
                Text("See who's going")
                    .font(.headline)
                    .bold()

            }
            
            ToolbarItem(placement: .primaryAction) {
                
                if let eventParticipants = event.participants {
                    Text("\(eventParticipants.count) / \(event.maxParticipants)")
                        .foregroundColor(.gray)
                        .bold()
                }
                  
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    EventAttendeeView(event: EventMock.instance.eventA)
}

