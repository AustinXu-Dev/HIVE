//
//  EventApproveOrReject.swift
//  HIVE
//
//  Created by Kelvin Gao  on 1/12/2567 BE.
//

import SwiftUI
import Kingfisher

struct EventApproveRejectView: View {
    @StateObject var organizingEventsVM = GetOngoingEventsViewModel()
    @StateObject var manageEventViewModel = ManageEventViewModel()

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(organizingEventsVM.organizingPrivateEvents, id: \._id) { event in
                        PendingParticipantRow(event: event)
                            .environmentObject(manageEventViewModel)
                    }
                }
                .padding(.horizontal)
            }
            .refreshable {
                refreshData()
            }
            .onAppear(perform: {
                refreshData()
            })
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("Activity")
//                        .font(.headline)
//                        .foregroundColor(.primary)
//                }
//            }
            .scrollIndicators(.hidden)
        
    }

    private func refreshData() {
        if let userId = KeychainManager.shared.keychain.get("appUserId"), let token = TokenManager.share.getToken() {
            organizingEventsVM.fetchOrganizingEventsConcurrently(userId: userId)
        } else {
            print("Error: Unable to retrieve user ID or token")
        }
    }
}

struct PendingParticipantRow: View {
    let event: EventModel
    @EnvironmentObject var manageEventViewModel: ManageEventViewModel
    @State private var participantActions: [String: manageAction] = [:] // Track actions by participant ID

    var body: some View {
        VStack {
          ForEach(event.pendingParticipants ?? [], id: \._id) { participant in
                HStack(spacing: 12) {
                    if let imageUrl = participant.profileImageUrl, let url = URL(string: imageUrl) {
                        KFImage(url)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.top, -30)
                    } else {
                        Image("profile_image")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.top, -30)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(participant.name ?? "")")
                          .heading5()
                          .foregroundStyle(Color.black)
                        +
                        Text(" wants to join ")
                          .body5()
                          .foregroundStyle(Color.black)
                        +
                      Text("\(event.name)")
                        .heading5()
                        .foregroundStyle(Color.black)
                        
                        HStack(spacing: 10) {
                          if let participantId = participant._id {
                                Button {
                                  handleApproveAction(eventId: event._id, participantId: participantId, action: .approve)
                                } label: {
                                    Text(participantActions[participantId] == .approve ? "Accepted" : "Accept")
                                        .heading6()
                                        .foregroundColor(.white)
                                        .frame(width: 146, height: 41)
                                        .background(Color("approveColor"))
                                        .cornerRadius(8)
                                }
                                .disabled(participantActions[participantId] == .approve) // Disable after action
                            }

                          if let participantId = participant._id {
                                Button {
                                  handleApproveAction(eventId: event._id, participantId: participantId, action: .reject)
                                } label: {
                                    Text(participantActions[participantId] == .reject ? "Removed" : "Remove")
                                        .heading6()
                                        .foregroundColor(.black)
                                        .frame(width: 146, height: 41)
                                        .background(Color("rejectColor"))
                                        .cornerRadius(8)
                                }
                                .disabled(participantActions[participantId] == .reject) // Disable after action
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }

    private func handleApproveAction(eventId: String, participantId: String, action: manageAction) {
        if let token = TokenManager.share.getToken() {
            manageEventViewModel.manageUser(eventId: eventId, participantId: participantId, action: action, token: token)
            participantActions[participantId] = action // Update the state
        } else {
            print("Error: Unable to retrieve token")
        }
    }
}


#Preview {
    EventApproveRejectView()
}
