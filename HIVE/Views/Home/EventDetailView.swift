//
//  ContentView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 18/10/2567 BE.
//

import SwiftUI
import Kingfisher

struct EventDetailView: View {
    var event : EventModel
    @EnvironmentObject private var eventsVM : GetEventsViewModel
    
    @State private var isCategoryExpanded: Bool = false
    
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject private var joinEventVM = JoinEventViewModel()
    @State private var eventAlreadyJoined : Bool = false
    @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue
    @State private var showCreateAccountAlert = false
    @State private var hasRequestedToJoin: Bool = false
    @State private var currentId: String = ""
    @State private var showAgeRestrictionAlert = false
    @State private var showErrorJoiningAlert = false
    @State private var isUnderage: Bool = false
    @State private var userIsApproved: Bool = false

    var comesFromHome: Bool
    @StateObject var profileVM = GetOneUserByIdViewModel()
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16){
                if joinEventVM.isLoading || profileVM.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    KFImage(URL(string: event.eventImageUrl))
                        .resizable()
                        .frame(height: 230)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                    
                    
                    Text(event.name)
                        .heading2()
                        .foregroundStyle(Color.black)
                    
                    eventCategories
                    
                    HStack{
                        Spacer()
                        if comesFromHome{
                            if let currentEvent = eventsVM.currentEvent {
                                ParticipantView(event: comesFromHome ? currentEvent : event, participantCount: 3)
                                    .onTapGesture {
                                        if userAppState != AppState.guest.rawValue {
                                            appCoordinator.push(.eventAttendeeView(named: comesFromHome ? currentEvent : event, comesFromHome: comesFromHome))
                                        } else {
                                            showCreateAccountAlert = true
                                        }
                                    }
                            }
                        } else {
                            ParticipantView(event: event, participantCount: 3)
                                .onTapGesture {
                                    if userAppState != AppState.guest.rawValue {
                                        appCoordinator.push(.eventAttendeeView(named: event, comesFromHome: comesFromHome))
                                    } else {
                                        showCreateAccountAlert = true
                                    }
                                }
                        }
                        
                    }
                    
                    Text(event.additionalInfo)
                        .body8()
                        .foregroundStyle(Color.black)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Host")
                            .heading6()
                            .foregroundStyle(Color.black.opacity(0.6))
                        HStack(alignment:.center) {
                            if let eventOrganizer = event.organizer {
                                KFImage(URL(string: eventOrganizer.profileImageUrl ?? ""))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                VStack(alignment: .leading) {
                                    Text(eventOrganizer.name ?? "Organizer")
                                        .heading7()
                                    Text(eventOrganizer.bio ?? "")
                                        .body8()
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                                .foregroundStyle(Color.black)
                                
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
                            .heading6()
                            .foregroundStyle(Color.black.opacity(0.6))
                        HStack {
                            Image("location")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:22,height:22)
                                .foregroundStyle(Color.gray)
                            if let isPrivate = event.isPrivate, !isPrivate {
                                Text(event.location)
                                    .heading8()
                                    .foregroundStyle(Color.black)
                            } else {
                                Text(checkApproval() ? event.location : "(Available after acceptance)")
                                    .heading8()
                            }
                        }
                        HStack {
                            Image("duration")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:22,height:22)
                                .foregroundStyle(Color.gray)
                            if let eventStartDate = event.startDate.formatDateString(), let startTime = event.startTime.to12HourFormat(), let endTime = event.endTime.to12HourFormat() {
                                Text("\(eventStartDate), \(startTime) - \(endTime)")
                                    .heading8()
                                    .foregroundStyle(Color.black)
                                
                            }
                        }
                        HStack {
                            Image("profile")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:22,height:22)
                                .foregroundStyle(Color.gray)
                            Text(
                                event.isPrivate ?? false
                                ? "Private" + (event.minAge ?? 0 > 1 ? ", \(event.minAge!)+": "")
                                : "Public" + (event.minAge ?? 0 > 1 ? ", \(event.minAge!)+": "")
                            )//(Available after acceptance)
                            .heading8()
                            .foregroundStyle(Color.black)
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
                                    if profileVM.isUnderage {
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
                                                .heading4()
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
                        .padding(.bottom,12)
                        
                    }
                }
            }
            .padding(.horizontal,12)
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
            .onReceive(joinEventVM.$joinFailure) { failure in
                if failure{
                    showErrorJoiningAlert = true
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
            .alert(isPresented: $showErrorJoiningAlert) {
                Alert(
                    title: Text("Unable to Join"),
                    message: Text(joinEventVM.errorMessage!),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            
            .onAppear {
                if comesFromHome{
                    if event._id != eventsVM.currentEvent?._id{
                        eventsVM.getOneEvent(id: event._id)
                    }
                    print("come from home")
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .refreshable {
            if comesFromHome{
                eventsVM.getOneEvent(id: event._id)
                print("come from home")
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
    
    func checkApproval() -> Bool {
        return ((event.participants?.contains(where: {$0._id == (profileVM.userDetail?._id ?? "")})) != nil)
        //    ForEach(event.participants ?? [], id: \._id){ participant in
        //      if participant._id == profileVM.userDetail?._id ?? "" {
        //        userIsApproved = true
        //      }
        //    }
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




extension EventDetailView {
    private var eventCategories : some View {
        HStack(spacing:8) {
            ForEach(event.category, id: \.self) { category in
                
                
                Text(category)
                    .foregroundColor(.black)
                    .body6()
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
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
