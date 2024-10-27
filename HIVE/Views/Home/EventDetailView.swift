//
//  ContentView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 18/10/2567 BE.
//

import SwiftUI
import Kingfisher

struct EventDetailView: View {
    let event : EventModel
    @State private var isCategoryExpanded: Bool = false
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject private var joinEventVM = JoinEventViewModel()
    @State private var eventAlreadyJoined : Bool = false
    var body: some View {
        
        ScrollView {
            VStack {
                if joinEventVM.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        KFImage(URL(string: event.eventImageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 270)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        Text(event.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        HStack {
                            eventCategories
                            //                    TagView(text: "drink")
                            //                    TagView(text: "Bar")
                            //                    TagView(text: "indoor")
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            //                    ZStack {
                            ParticipantView(event: event)
                                .onTapGesture {
                                        appCoordinator.push(.eventAttendeeView(named: event))
                                    
                                }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                        
                        Text(event.additionalInfo)
                            .font(.body)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Host")
                                .font(.headline)
                            HStack {
                                if let eventOrganizer = event.organizer {
                                    KFImage(URL(string: eventOrganizer.profileImageUrl ?? ""))
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    VStack(alignment: .leading) {
                                        Text(eventOrganizer.name ?? "Organizer")
                                            .fontWeight(.bold)
                                        Text(eventOrganizer.bio ?? "")
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Details")
                                .font(.headline)
                            HStack {
                                Image(systemName: "mappin.circle")
                                Text(event.location)
                            }
                            HStack {
                                Image(systemName: "calendar")
                                if let eventStartDate = event.startDate.formatDateString(), let startTime = event.startTime.to12HourFormat(), let endTime = event.endTime.to12HourFormat() {
                                    Text("\(eventStartDate), \(startTime) - \(endTime)")
                                }
                            }
                            HStack {
                                Image(systemName: "person.3")
                                Text("Anyone")
                            }
                        }
                        .padding(.horizontal)
                        if let currentUserId = KeychainManager.shared.keychain.get("appUserId"),
                           currentUserId != event.organizer?.userid {
                            
                            VStack {
                                Spacer()
                                
                                
                                Button(action: {
                                    if let userToken = TokenManager.share.getToken(), !eventAlreadyJoined {
                                        joinEventVM.joinEvent(eventId: event._id, token: userToken)
                                    }
                                    
                                    
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.purple, lineWidth: 5)
                                            .shadow(color: Color.purple.opacity(0.4), radius: 20, x: 0, y: 0)
                                            .shadow(color: Color.purple.opacity(0.4), radius: 40, x: 0, y: 0)
                                            .frame(width: 300, height: 60)
                                            .overlay {
                                                Text(eventAlreadyJoined ? "Joined" :"Join")
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.black)
                                                    .frame(width: 300, height: 60)
                                                    .background(Color.white)
                                                    .cornerRadius(25)
                                                
                                            }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(maxWidth: .infinity)
                            }
                            Spacer()
                            
                                .padding()
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarBackButtonHidden()
//            .onChange(of: joinEventVM.joinSuccess) { _,success in
//                if success {
//                    eventAlreadyJoined = true
//                    appCoordinator.push(.eventJoinSuccess)
//                }
//            }
            .onAppear {
                eventAlreadyJoinedOrNot()
            }
            .onReceive(joinEventVM.$joinSuccess) { success in
                if success {
                    eventAlreadyJoined = true // Update after joining successfully
                    appCoordinator.push(.eventJoinSuccess)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Text("< Back")
                        .onTapGesture {
                            appCoordinator.pop()
                        }
                }
            }
        }
    }
    
    func eventAlreadyJoinedOrNot()  {
        guard let currentUserId = KeychainManager.shared.keychain.get("appUserId") else { return }
        eventAlreadyJoined = event.participants?.contains(where: {$0.userid == currentUserId}) ?? false
        
//        event.participants?.forEach({ user in
//            if user.userid == currentUserId {
//                eventAlreadyJoined = true
//
//            } else {
//                eventAlreadyJoined = false
//            }
//            
//        })
//        eventAlreadyJoined = event.participants?.contains { $0._id == currentUserId } ?? false

    }

    
    
}

struct TagView: View {
    let text: String
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(1))
            .cornerRadius(8)
    }
}

#Preview {
    EventDetailView(event: EventMock.instance.eventA)
}


extension EventDetailView {
    private var eventCategories : some View {
        HStack(spacing:8) {
            ForEach(event.category, id: \.self) { category in
          
          
                Text(category)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 2)
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8)
                    .fixedSize(horizontal: true, vertical: false)
                
                          }
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
//                ForEach(event.category, id: \.self) { category in
//                    
//                
//                    Text(category)
//                        .foregroundColor(.white)
//                        .font(.subheadline)
//                        .padding(.vertical, 6)
//                        .padding(.horizontal, 2)
//                        .background(Color.gray.opacity(1))
//                        .cornerRadius(8)
//                        .fixedSize(horizontal: true, vertical: false)
//                    
//                }
//            }
//            .frame(maxWidth:350)
            
            
            // Expand/Collapse Button
//            Button(action: {
//                withAnimation(.linear(duration: 0.35)){
//                    isCategoryExpanded.toggle()
//                }
//            }) {
//                Circle()
//                    .frame(height:27)
//                    .foregroundStyle(Color.black)
//                    .overlay (
//                        Image(systemName: "chevron.down")
//                            .rotationEffect(.degrees(isCategoryExpanded ? 180 : 0))
//                            .foregroundStyle(.white)
//                    )
//                
//            }
          
        }
        
    }
}
