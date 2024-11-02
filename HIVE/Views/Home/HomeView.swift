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


    var body: some View {
        
            ScrollView(.vertical,showsIndicators: false) {
            if eventsVM.isLoading {
                VStack {
                    ProgressView()
                }
            } else {
                VStack(alignment: .center,spacing:14) {
                    headerRow
                        .padding(.horizontal)
                    if TokenManager.share.getToken() == nil {
                        accountCreationButton
                    }
                    eventsScrollView
                }
                .padding(.horizontal)
                
            }
        }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden()
            .refreshable {
                eventsVM.fetchEvents()
            }
        
          
        
    }

    private var eventsScrollView: some View {
        VStack(alignment: .leading) {
            Text("Explore")
                .padding(.horizontal)

          //  ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    ForEach(filteredEvents, id: \._id) { event in
                        EventCard(event: event)
                            
                            .onTapGesture {
                                appCoordinator.push(.eventDetailView(named: event))
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
        HStack {
            Image("HIVE")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 78, height: 34)
            Spacer()
            Menu {
                ForEach(TimeFilter.allCases, id: \.self) { filter in
                    Button(action: {
                        selectedTimeFilter = filter
                    }) {
                        Text(filter.rawValue)
                    }
                }
            } label: {
                Label("\(selectedTimeFilter.rawValue)", systemImage: "calendar")
                    .padding()
                    .foregroundStyle(Color.black)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(8)
            }
           
        }
    }

    private var accountCreationButton: some View {
        VStack {
            Text("Ready to Connect?")
                .bold()
            Button {
                appCoordinator.push(.signIn)
            } label: {
                Text("Create an Account")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
           
            Text("To join or host your own!")
                .bold()
        }
    }
}


enum TimeFilter: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
}
