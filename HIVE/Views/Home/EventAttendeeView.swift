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
    @StateObject var kickParticipantVM = KickParticipantViewModel()
    @State var showAlert = false

    var body: some View {
        VStack {
            Divider()
            
            List(event.participants ?? [], id: \.userid) { participant in
                HStack {
                    KFImage(URL(string: participant.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(participant.name ?? "Unknown")
                            .font(CustomFont.attendeeTitle)
                        
                        Text(participant.bio ?? "")
                            .font(CustomFont.attendeeDescription)
                            .foregroundColor(.gray)
                    }
                  
                    Spacer()
                    
                    if checkOrganizer(){
                        Button(action: {
                            showAlert = true
                        }) {
                            Text("Kick")
                                .foregroundStyle(.red)
                                .font(CustomFont.pendingParticipantBoldText)
                        }
                        .tint(Color("kickButtonColor"))
                        .buttonStyle(.borderedProminent)
                        .alert("Are you sure you want to kick?", isPresented: $showAlert, actions: {
                            Button("OK", role: .cancel) {
                                kickAction(eventId: event._id, participantId: participant.userid ?? "")
                            }
                            Button("Cancel", role: .destructive) { }
                        })
                    }

                }
                .padding(.horizontal)
                .frame(maxWidth:.infinity)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.000001))
                .onTapGesture {
                    appCoordinator.push(.participantProfile(named: participant))
                }
            }
            .listStyle(PlainListStyle())
            .scrollIndicators(.hidden)
            

            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
              Button(action: {
                appCoordinator.pop()
              }) {
                Image(systemName: "chevron.left")
                  .font(.title2)
                  .foregroundColor(.black)
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

        .alert("Alert",isPresented: $kickParticipantVM.kickSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(kickParticipantVM.successMessage ?? "")
        }
        
        .navigationBarBackButtonHidden()
    }
    
    func kickAction(eventId: String, participantId: String) -> Void {
        kickParticipantVM.kickParticipants(eventId: eventId, participantId: participantId, token: TokenManager.share.getToken() ?? "")
    }
    
    func checkOrganizer() -> Bool{
        if let currentUserId = KeychainManager.shared.keychain.get("appUserId"){
            return currentUserId == event.organizer?.userid
        } else {
            return false
        }
    }
}

#Preview {
    EventAttendeeView(event: EventMock.instance.eventA)
}

