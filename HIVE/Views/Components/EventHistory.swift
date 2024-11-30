//
//  EventHistory.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 30/11/2024.
//

import SwiftUI

struct EventHistory: View {
  
  @StateObject var viewModel = EventHistoryViewModel()
  @State private var showHostingView: Bool = false
  @State private var showErrorMessage: Bool = false
  var body: some View {
    ZStack {
      if viewModel.isLoading {
        ProgressView("Loading...")
      } else {
        VStack(alignment:.center,spacing: 24) {
          

          HStack {
            VStack(alignment:.center,spacing: 2) {
              Text("Joined")
                .foregroundStyle(Color.black)
                .font(.headline)
                .bold()
                .onTapGesture {
                  print("tapped")
                  withAnimation(.smooth.speed(5.0)) {
                    showHostingView = true
                  }
                }
              Rectangle()
                .frame(width:128,height: 1.5)
                .opacity(showHostingView ? 1 : 0)
            }
            Spacer()
            VStack(alignment:.center,spacing: 2) {
              Text("Hosted")
                .font(.headline)
                .bold()
                .foregroundStyle(Color.black)
                .onTapGesture {
                  print("tapped")
                  withAnimation(.smooth.speed(5.0)) {
                    showHostingView = false
                  }
                }
              Rectangle()
                .frame(width:128,height: 1.5)
                .opacity(showHostingView ? 0 : 1)
            }
          }
          .padding(.horizontal,20)
          
          if !showHostingView {
          ForEach(viewModel.joinedEventHistory,id: \._id){ event in
            VStack(alignment:.center,spacing: 12){
              EventRow(event: event)
              if showErrorMessage {
                Text(viewModel.errorMessage ?? "")
              }
            }
            
          }
          } else {
            ForEach(viewModel.hostedEventHistory,id: \._id){ event in
              VStack(alignment:.center,spacing: 12){
                EventRow(event: event)
                if showErrorMessage {
                  Text(viewModel.errorMessage ?? "")
                }
              }
              
            }
          }
      }
    .padding(.horizontal)
    }
  }
    .onChange(of: viewModel.errorMessage, { _, _ in
      showErrorMessage = true
    })
      .onAppear {
        if let userId = KeychainManager.shared.keychain.get("appUserId"), let token = TokenManager.share.getToken() {
          print("user id is \(userId)")
          viewModel.getJoinedEventHistory(id: userId,token: token)
          viewModel.getOrganizedEventHistory(id: userId, token: token)
        }
      }
    }
}

#Preview {
  EventHistory(viewModel: EventHistoryViewModel())
}
