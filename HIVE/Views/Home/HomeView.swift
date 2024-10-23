//
//  HomeView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @StateObject private var eventsVM = GetEventsViewModel()
    @State private var searchText: String = ""
    @State private var selectedTimeFilter: TimeFilter = .all
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl



    var body: some View {
            VStack {
                VStack(alignment: .center) {
                    headerRow
                    if TokenManager.share.getToken() == nil {
                        accountCreationButton
                    }
                }
                Spacer()
                if eventsVM.isLoading {
                    ProgressView()
                } else if filteredEvents.isEmpty {
                    Text("No events found")
                        .padding()
                } else {
                    eventsScrollView
                }
            }
            .padding(.horizontal)
            .onAppear {
                eventsVM.fetchEvents()
            }
            // Move the search bar out of the toolbar
            .searchable(text: $searchText, placement: .automatic, prompt: "Search events")
            .refreshable {
                eventsVM.fetchEvents()
            }
        
    }

    private var eventsScrollView: some View {
        VStack(alignment: .leading) {
            Text("Explore")
                .padding(.horizontal)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    ForEach(filteredEvents, id: \._id) { event in
                        EventCard(event: event)
                            
                            .onTapGesture {
                                appCoordinator.push(.eventDetailView(named: event))
                            }
                    }
                }
            }
        }
    }
    
    private var filteredEvents: [EventModel] {
        // First, filter by search text
        let filteredBySearch = searchText.isEmpty ? eventsVM.events : eventsVM.events.filter { event in
            event.name.localizedCaseInsensitiveContains(searchText)
        }
        // Apply the time filter
        return filteredBySearch.filter { event in
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
//            RoundedRectangle(cornerRadius: 10)
//                .frame(width: 133, height: 34)
//                .foregroundStyle(.gray)
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
