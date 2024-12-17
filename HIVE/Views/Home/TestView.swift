//
//  TextView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 01/12/2024.
//

import SwiftUI

struct TestView: View {
  @StateObject var viewModel = ManageEventViewModel()
  @StateObject var onGoingEventViewModel = GetOngoingEventsViewModel()
  @State private var status: String = ""
  @State private var error: String = ""
    var body: some View {
      VStack {
        HStack {
          Button {
            viewModel.manageUser(eventId: "674b766eab920bc36ea48625", participantId: "672da237d4c3bf82d6461f92", action: .approve, token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MmNmNGRmMDRmNzZkZTk5YzU2MmVlNSIsImlhdCI6MTczMjk5OTA3NiwiZXhwIjoxNzMzMDg1NDc2fQ.GGMRcWqn1VgMrbrbg41ApOOMCDoxPe1pyDLZHv6ZBBY")
          } label: {
            Text("Approvew")
          }
          
          Button {
            viewModel.manageUser(eventId: "674b766eab920bc36ea48625", participantId: "673ae17b3a502feab78c5a81", action: .reject, token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MmNmNGRmMDRmNzZkZTk5YzU2MmVlNSIsImlhdCI6MTczMjk5OTA3NiwiZXhwIjoxNzMzMDg1NDc2fQ.GGMRcWqn1VgMrbrbg41ApOOMCDoxPe1pyDLZHv6ZBBY")
          } label: {
            Text("Reject")
          }
        }
        Text(status)
          .font(.headline)
          .bold()
        Text(error)
          .font(.headline)
          .bold()
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
              ForEach(onGoingEventViewModel.organizingPrivateEvents, id: \._id) { event in
                    VStack(alignment: .leading) {
                        Text(event.name ?? "")
                          .font(.headline)
                          .bold()
                        Text("Pending Participants:")
                          .font(.subheadline)
                          .bold()
                      
                      if let eventParticipants = event.pendingParticipants {
                        PendingParticipantsView(participants: eventParticipants)
                      }

                        Divider()
                    }
                }
            }
        }

        
        
        
        
      }
      .onAppear(perform: {
        
        onGoingEventViewModel.getOrganizingEventsOfUser(userId: "672cf4df04f76de99c562ee5", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3MmNmNGRmMDRmNzZkZTk5YzU2MmVlNSIsImlhdCI6MTczMzAzNTA1MiwiZXhwIjoxNzMzMTIxNDUyfQ.RgH7J6fE1gGxeZOjVAWhH0GkuuzdSREKu9csfuxBOJ8")
      })
      .onChange(of: viewModel.manageSuccessful) { _, result in
        if result {
          status = "Success"
        } else {
          status = "Failure"
        }
      }
      .onChange(of: viewModel.errorMessage ?? "") { _, newValue in
        error = newValue
      }
    }
}




struct PendingParticipantsView: View {
  let participants: [UserModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(participants, id: \._id) { participant in
                VStack(alignment: .leading, spacing: 10) {
                    Text(participant.name ?? "")
                        .font(.headline)
                        .bold()
                }
            }
        }
    }
}
