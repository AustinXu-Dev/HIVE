//
//  EventApproveOrReject.swift
//  HIVE
//
//  Created by Kelvin Gao  on 1/12/2567 BE.
//

import SwiftUI
import Kingfisher

struct EventApproveRejectView: View {
    @StateObject var ongoingEventsVM = GetOngoingEventsViewModel()
    @StateObject var manageEventViewModel = ManageEventViewModel()

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(ongoingEventsVM.privateHostingEvents, id: \._id) { event in
                        PendingParticipantRow(event: event, pendingParticipants: event.pendingParticipants ?? [])
                            .environmentObject(manageEventViewModel)
                    }
                }
                .padding(.horizontal)
            }
            .refreshable {
                refreshData()
            }
           
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
        
    }

    private func refreshData() {
        if let userId = KeychainManager.shared.keychain.get("appUserId") {
          ongoingEventsVM.fetchOrganizingEventsConcurrently(userId: userId)
        } else {
            print("Error: Unable to retrieve user ID or token")
        }
    }
}

struct PendingParticipantRow: View {
    let event: EventModel
    let pendingParticipants: [UserModel]
    @EnvironmentObject var manageEventViewModel: ManageEventViewModel
    @State private var participantActions: [String: manageAction] = [:] // Track actions by participant ID

    var body: some View {
      VStack {
        ForEach(pendingParticipants, id: \._id) { participant in
          VStack(alignment:.leading,spacing:12) {
            HStack(spacing: 8) {
              profile(participant: participant)
              participantText(participant: participant)
            }
            HStack(spacing: 12) {
              approveButton(participant: participant)
              rejectButton(participant: participant)
            }
          }
        }
      }
   
    }
}


#Preview {
    EventApproveRejectView()
}


extension PendingParticipantRow {

  private func profile(participant: UserModel) -> some View {
    Group {
      if let imageUrl = participant.profileImageUrl, let url = URL(string: imageUrl) {
         KFImage(url)
          .resizable()
          .frame(width: 50, height: 50)
          .clipShape(Circle())
      } else {
         Image("profile_image")
          .resizable()
          .frame(width: 50, height: 50)
          .clipShape(Circle())
      }
    }
  }


  
  private func participantText(participant:UserModel) -> some View {
    Text(attributedPendingParticipantText(participant: participant, event: event))
      .multilineTextAlignment(.leading)
      .foregroundStyle(Color.black)
      .lineLimit(nil)
  }
  
  
  func attributedPendingParticipantText(participant: UserModel, event: EventModel) -> AttributedString {
    var string = AttributedString("\(participant.name ?? "") wants to join \(event.name)")
    string.font =  .custom(LatoFont.boldFont, size: 20)

        

        if let range = string.range(of: "wants to join") {
          string[range].font =  .custom(LatoFont.regularFont, size: 18)
        }

        return string
    }
  
  
    private func handleApproveAction(eventId: String, participantId: String, action: manageAction) {
        if let token = TokenManager.share.getToken() {
            manageEventViewModel.manageUser(eventId: eventId, participantId: participantId, action: action, token: token)
            participantActions[participantId] = action // Update the state
        } else {
            print("Error: Unable to retrieve token")
        }
    }
  
  private func approveButton(participant: UserModel) -> some View {
    Group {
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
    }
  }
  
  
  private func rejectButton(participant: UserModel) -> some View {
    Group {
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
  }
}
