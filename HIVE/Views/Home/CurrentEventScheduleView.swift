//
//  CurrentEventScheduleView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 11/12/2024.
//

import SwiftUI

struct CurrentEventScheduleView: View {
  
  @StateObject var viewModel = GetOngoingEventsViewModel()
  @State private var showHosting: Bool = false
  var body: some View {
    VStack {
      HStack {
        VStack{
          Text("Upcoming")
            .bold()
            .font(.headline)
            .onTapGesture {
              showHosting = true
            }
          Rectangle()
            .frame(width:200,height:2)
            .foregroundStyle(Color.black)
            .opacity(showHosting ? 0 : 1)
        }
       
        VStack{
          Text("Hosting")
            .bold()
            .font(.headline)
            .onTapGesture {
              showHosting = false
            }
          Rectangle()
            .frame(width:200,height:2)
            .foregroundStyle(Color.black)
            .opacity(showHosting ? 1 : 0)
        }
      }
    ScrollView(.vertical,showsIndicators: false){
      VStack {
        ForEach(showHosting ? viewModel.organizingEvents : viewModel.joiningEvents,id: \._id){ event in
          
          CurrentEventRow(event: event)
          
        }
      }
    }
  }
      .padding(.horizontal)
    }
}

#Preview {
    CurrentEventScheduleView()
}
