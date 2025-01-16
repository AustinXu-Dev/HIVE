//
//  SeeWhoGoingView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 19/10/2567 BE.
//

import SwiftUI
import Kingfisher


struct EventAttendeeView: View {
    @State var event : EventModel
    @EnvironmentObject private var eventsVM : GetEventsViewModel

    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject var kickParticipantVM = KickParticipantViewModel()
    @State var showAlert = false

    var body: some View {
        ScrollView {
            VStack{
                ForEach(eventsVM.currentEvent?.participants ?? [], id: \._id) { participant in
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
                                .lineLimit(1)
                                .truncationMode(.tail)
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
                                    kickAction(eventId: event._id, participantId: participant._id ?? "")
                                    
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
                        appCoordinator.push(.socialProfile(user: participant))
                        
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                Text("Participants")
                    .font(.headline)
                    .bold()

            }
            
            ToolbarItem(placement: .primaryAction) {
                
                if let eventParticipants = eventsVM.currentEvent?.participants {
                    Text("\(eventParticipants.count) / \(eventsVM.currentEvent?.maxParticipants ?? 0)")
                        .foregroundColor(.gray)
                        .bold()
                }
                  
            }
        }

        .alert("Kicked",isPresented: $kickParticipantVM.kickSuccess) {
            Button("OK", role: .cancel) {
                eventsVM.getOneEvent(id: event._id)
            }
        } message: {
            Text(kickParticipantVM.successMessage ?? "")
        }
        .refreshable {
            eventsVM.getOneEvent(id: event._id)
        }
        
        .navigationBarBackButtonHidden()
    }
    
    func kickAction(eventId: String, participantId: String) -> Void {
        kickParticipantVM.kickParticipants(eventId: eventId, participantId: participantId, token: TokenManager.share.getToken() ?? "")
    }
    
    func checkOrganizer() -> Bool{
        if let currentUserId = KeychainManager.shared.keychain.get("appUserId"){
          return currentUserId == event.organizer?._id

        } else {
            return false
        }
    }
}

#Preview {
    EventAttendeeView(event: EventMock.instance.eventA)
}

