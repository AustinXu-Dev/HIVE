//
//  EventHistory.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 30/11/2024.
//

import SwiftUI

struct EventHistory: View {
  
  @ObservedObject var viewModel: EventHistoryViewModel
  @State private var showHostingView: Bool = false
  @State private var showErrorMessage: Bool = false
  @EnvironmentObject var appCoordinator: AppCoordinatorImpl

  var body: some View {
    ZStack {
        VStack(alignment:.center,spacing: 24) {
          HStack {
            VStack(alignment:.center,spacing: 2) {
              Text("Joined")
                .foregroundStyle(Color.black)
                .body4()
                .bold()
                .onTapGesture {
                  withAnimation(.smooth.speed(5.0)) {
                    showHostingView = false
                  }
                }
              Rectangle()
                .frame(width:128,height: 1.5)
                .opacity(showHostingView ? 0 : 1)
            }
            Spacer()
            VStack(alignment:.center,spacing: 2) {
              Text("Hosted")
                .body4()
                .bold()
                .foregroundStyle(Color.black)
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
          }
          .padding(.horizontal,20)
          
          if !showHostingView {
            //if no events
            if viewModel.joinedEventHistory.count != 0 {
            ForEach(viewModel.joinedEventHistory,id: \._id){ event in
              VStack(alignment:.center,spacing: 12){
                EventRow(event: event)
                  .onTapGesture {
                      appCoordinator.push(.eventDetailView(named: event, comesFromHome: false))
                  }
                
              }
              
            }
            } else {
              noEvents
            }
          } else {
            if viewModel.hostedEventHistory.count != 0 {
              ForEach(viewModel.hostedEventHistory,id: \._id){ event in
                VStack(alignment:.center,spacing: 12){
                  EventRow(event: event)
                    .onTapGesture {
                        appCoordinator.push(.eventDetailView(named: event, comesFromHome: false))
                    }
                }
                
              }
            } else {
              noEvents
            }
          }
      }
    .padding(.horizontal)
    
  }
    .onAppear {
      showHostingView = false
    }
    .onChange(of: viewModel.errorMessage, { _, _ in
      showErrorMessage = true
    })
  
  
    }
}


extension EventHistory {
  private var noEvents: some View {
    ZStack {
      Color.white
      VStack(alignment:.center,spacing: 12){
        Image(systemName: "calendar.badge.exclamationmark")
          .resizable()
          .scaledToFit()
          .frame(width:60,height: 60)
        Text("No Activities Yet")
          .font(.subheadline)
          .fontWeight(.medium)
      }
    }
  }
}
