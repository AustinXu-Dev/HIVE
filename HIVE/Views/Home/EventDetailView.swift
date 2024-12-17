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
    @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue
    @State private var showCreateAccountAlert = false
    @State private var hasRequestedToJoin: Bool = false
    @State private var currentId: String = ""
    @State private var showAgeRestrictionAlert = false
    @State private var isUnderage: Bool = false
    
    @StateObject var profileVM = GetOneUserByIdViewModel()
        
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
                            .frame(width: UIScreen.main.bounds.width * 0.90)
                            .frame(height: 230)
                            .cornerRadius(10)
                        
                        
                        Text(event.name)
                            .font(CustomFont.eventTitleStyle)
                            .fontWeight(.bold)
                        
                        HStack {
                            eventCategories
                        }
                        
                        
                        HStack(spacing: 20) {
                            Spacer()
                            ParticipantView(event: event)
                                .onTapGesture {
                                    if userAppState != AppState.guest.rawValue {
                                        appCoordinator.push(.eventAttendeeView(named: event))
                                    } else {
                                        showCreateAccountAlert = true
                                    }
                                }
                        }
                        .frame(alignment: .trailing)
                        
                        
                        Text(event.additionalInfo)
                            .font(CustomFont.eventBodyStyle)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Host")
                                .font(CustomFont.eventSubtitleStyle)
                                .fontWeight(.semibold)
                            HStack {
                                if let eventOrganizer = event.organizer {
                                    KFImage(URL(string: eventOrganizer.profileImageUrl ?? ""))
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    VStack(alignment: .leading) {
                                        Text(eventOrganizer.name ?? "Organizer")
                                            .font(CustomFont.hostTitle)
                                        Text(eventOrganizer.bio ?? "")
                                            .font(CustomFont.hostDescription)
                                    }
                                }
                            }
                        }
                        .onTapGesture {
                            if userAppState != AppState.guest.rawValue {
                                if let eventOrganizer = event.organizer {
                                  appCoordinator.push(.socialProfile(user: eventOrganizer))
                                }
                            } else {
                                showCreateAccountAlert = true
                                
                            }
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Details")
                                .font(CustomFont.eventSubtitleStyle)
                                .fontWeight(.semibold)
                            HStack {
                                Image("location")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:22,height:22)
                                Text(event.location)
                                    .font(CustomFont.detail)
                            }
                            HStack {
                                Image("duration")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:22,height:22)
                                if let eventStartDate = event.startDate.formatDateString(), let startTime = event.startTime.to12HourFormat(), let endTime = event.endTime.to12HourFormat() {
                                    Text("\(eventStartDate), \(startTime) - \(endTime)")
                                        .font(CustomFont.detail)
                                }
                            }
                            HStack {
                                Image("profile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:22,height:22)
                                Text(event.isPrivate ?? false ? "Private, \(event.minAge ?? 18)+" : "Public, \(event.minAge ?? 18)+")
                                    .font(CustomFont.detail)
                            }
                        }
                        
                        HStack {
                            Spacer()
                            if userAppState == AppState.guest.rawValue {
                                Button {
                                    appCoordinator.popToRoot()
                                    userAppState =  AppState.notSignedIn.rawValue
                                } label: {
                                    ReusableAccountCreationButton()
                                }
                                .frame(alignment:.center)
                            }
                            Spacer()
                        }
                        
                        
                        if let currentUserId = KeychainManager.shared.keychain.get("appUserId"),
                           currentUserId != event.organizer?._id && userAppState == AppState.signedIn.rawValue {
                            
                            VStack(alignment:.center) {
                                Spacer()
                                Button(action: {
                                    if let userToken = TokenManager.share.getToken(), !eventAlreadyJoined {
                                        
                                        if profileVM.isUnderage{
                                            showAgeRestrictionAlert = true
                                        } else {
                                            joinEventVM.joinEvent(eventId: event._id, token: userToken)
                                        }
                                    }
                                }) {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 25)
                                            .shadow(color: Color("shadowColor"), radius: 5, x: 0, y: 0)
                                            .frame(width: 200, height: 60)
                                            .overlay {
                                                Text(getButtonText())
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.black)
                                                    .frame(width: 200, height: 60)
                                                    .background(Color.white)
                                                    .cornerRadius(25)
                                            }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .shadow(color: Color("shadowColor"), radius: 10, x: 0, y: 0)
                            }
                            .frame(maxWidth:.infinity,alignment:.center)
                            
                        }
                    }
                    .padding(.horizontal,20)
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarBackButtonHidden()
            .onAppear {
                eventAlreadyJoinedOrNot()
            }
            .onReceive(joinEventVM.$joinSuccess) { success in
                if success {
                    eventAlreadyJoined = true // Update after joining successfully
                    appCoordinator.push(.eventJoinSuccess(isPrivate: event.isPrivate ?? false)) 
                }
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
            }
            .alert(isPresented: $showCreateAccountAlert) {
                Alert(
                    title: Text("You must create or log in to an account, first"),
                    primaryButton: .default(Text("Sign Up/Sign In"), action: {
                        appCoordinator.popToRoot()
                        userAppState = AppState.notSignedIn.rawValue
                    }),
                    secondaryButton: .destructive(Text("Cancel"))
                )
            }
            .alert(isPresented: $showAgeRestrictionAlert) {
                Alert(
                    title: Text("Age Restriction"),
                    message: Text("You do not meet the minimum age requirement of \(event.minAge ?? 18)."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            
        }
    }
    
    private func getButtonText() -> String{
        if event.isPrivate ?? false {
            if eventAlreadyJoined {
                return "Joined"
            } else if hasRequestedToJoin{
                return "Requested"
            } else {
                return "Request"
            }
        } else {
            return eventAlreadyJoined ? "Joined" : "Join"
        }
    }
    
    func eventAlreadyJoinedOrNot()  {
        guard let currentUserId = KeychainManager.shared.keychain.get("appUserId") else { return }
        profileVM.getOneUserAndCheckAge(id: currentUserId, eventMinAge: event.minAge ?? 0)
      self.eventAlreadyJoined = self.event.participants?.contains(where: { $0._id == currentUserId }) ?? false
      self.hasRequestedToJoin = self.event.pendingParticipants?.contains(where: { $0._id == currentUserId }) ?? false
        
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
                    .foregroundColor(.black)
                    .font(CustomFont.eventSubtitleStyle)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1.5)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .fixedSize(horizontal: true, vertical: false)
                
                
            }
        }
        
    }
}
