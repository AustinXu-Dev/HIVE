//
//  HomeView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @EnvironmentObject private var eventsVM : GetEventsViewModel
    @State private var selectedTimeFilter: TimeFilter = .all
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @Environment(\.isGuest) private var isGuest: Bool
    @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue
    let screenSize = UIScreen.main.bounds.size
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            if eventsVM.isLoading {
                ProgressView("Loading...")
            } else {
                ScrollView(.vertical,showsIndicators: false) {
                    VStack(alignment: .center,spacing:14) {
                        if isGuest {
                            accountCreationButton
                        }
                        eventsScrollView
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
                .refreshable {
                    eventsVM.fetchEvents()
                }
                .navigationBarBackButtonHidden()
                .toolbar(.hidden)
                .onAppear {
                    print("user app State \(userAppState)")
                }
                .safeAreaInset(edge: .top, content: {
                    Color.clear
                        .frame(height: 70)
                })
                .overlay {
                    headerRow
                }
                
            }
        }

        .onTapGesture {
            print("screen is is pressed")
        }
        .alert(isPresented: $eventsVM.showErrorAlert){
            Alert(title: Text("⚠️Fail to get the events⚠️"),
                  message: Text(eventsVM.errorMessage ?? ""),
                  dismissButton: .cancel(Text("OK"))
            )
        }
        
        
        
        
    }
    
    private var eventsScrollView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Explore")
                    .heading5()
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .frame(alignment: .leading)
                Spacer()
            }
            //  ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment:.leading, spacing: 30) {
                ForEach(filteredEvents, id: \._id) { event in
                    EventCard(event: event)
                        .contentShape(TopRoundedCorners(radius: 20))
                        .onTapGesture {
                            eventsVM.currentEvent = event
                            appCoordinator.push(.eventDetailView(named: event, comesFromHome: true))
                        }
                }
            }
            //  }
        }
    }
    
    private var filteredEvents: [EventModel] {
        // Apply the time filter
        return eventsVM.events.filter { event in
            matchesTimeFilter(event: event)
        }
    }
    
    
    
    private func matchesTimeFilter(event: EventModel) -> Bool {
        guard let eventStartDate = parseDate(event.startDate) else { return false }
        let currentDate = Date()
        
        switch selectedTimeFilter {
        case .all:
            return true
        case .today:
            return Calendar.current.isDate(eventStartDate, inSameDayAs: currentDate)
        case .thisWeek:
            return Calendar.current.isDate(eventStartDate, equalTo: currentDate, toGranularity: .weekOfYear)
        case .thisMonth:
            return Calendar.current.isDate(eventStartDate, equalTo: currentDate, toGranularity: .month)
        }
    }
    
    // Parse the event date string and convert it to Thailand's local time zone
    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Adjust based on your event date format
        formatter.timeZone = TimeZone(identifier: "Asia/Bangkok") // Thailand time zone
        
        if let date = formatter.date(from: dateString) {
            // No need for conversion as it's already in Thailand's time zone
            return date
        }
        return nil
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

extension HomeView {
    private var headerRow: some View {
        ZStack{
            Color.clear
                //.frame(height: 120)
                .frame(height:screenSize.height <= 667 ? 90 : 120)
                .background(.white)
                .blur(radius: 1)
                .ignoresSafeArea(edges: .top)
            HStack {
                Menu {
                    ForEach(TimeFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            selectedTimeFilter = filter
                        }) {
                            Text(filter.rawValue)
                        }
                    }
                } label: {
                    Label("\(selectedTimeFilter.rawValue)", systemImage: "slider.horizontal.3")
                        .foregroundStyle(Color.black)
                        .aspectRatio(contentMode: .fit)
                        .frame(width:26,height:26)
                }
                
                Spacer()
                
                Image(.HIVE)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 78,height: 34)
                    .offset(x:8)
                    .padding(.leading, 20)
                
                Spacer()
                
                HStack(spacing:4) {
                    Image(systemName: "bell")
                        .aspectRatio(contentMode: .fit)
                        .frame(width:27,height:27)
                        .onTapGesture {
                            print("bell is pressed")
                            appCoordinator.push(.eventApproveRejectView)
                        }
                    Image(systemName: "calendar")
                        .aspectRatio(contentMode: .fit)
                        .frame(width:30,height:30)
                        .onTapGesture {
                            appCoordinator.push(.eventSchedule)
                        }
                }
            }
            .offset(y: -30)
            .padding(.horizontal)
        }.frame(maxHeight: .infinity, alignment: .top)
    }
    
    private var accountCreationButton: some View {
        VStack {
            Text("Ready to Connect?")
                .heading4()
            Button {
                userAppState =  AppState.notSignedIn.rawValue
            } label: {
                ReusableAccountCreationButton()
            }
            
            Text("To join or host your own!")
                .body5()
        }
    }
}


enum TimeFilter: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
}
