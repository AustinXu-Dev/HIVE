//  EventSearchView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 18/10/2567 BE.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var hasResults = true
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var eventsVM : GetEventsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                    .padding(.leading, 10)
                
                TextField("Find interests, meetups, or hosts...", text: $searchText, onCommit: {
                    hasResults = performSearch(for: searchText)
                })
                .padding(10)
                
                Spacer()
            }
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.black, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            
            Spacer()
            
            if !hasResults {
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                    
                    Text("No Results")
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    appCoordinator.push(.eventCreationForm)
                }) {
                    Text("Be the first to host one! 🥳")
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width / 2)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(24.5)
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .offset(y: -30)
                
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(eventsVM.events.filter { event in
                            event.name.contains(searchText) || (event.organizer?.name?.contains(searchText) ?? false)
                        }, id: \.self) { event in
                            EventCard(event: event)
                                .onTapGesture {
                                    appCoordinator.push(.eventDetailView(named: event))
                                }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            dismissKeyboard()
        }
    }
    
    func performSearch(for query: String) -> Bool {
        return eventsVM.events.contains { event in
            event.name.contains(query) || (event.organizer?.name?.contains(query) ?? false)
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SearchView()
}


extension SearchView {
    
    private var eventsScrollView: some View {
        VStack(alignment: .leading) {
            Text("Explore")
                .padding(.horizontal)
            
            VStack(spacing: 30) {
                ForEach(eventsVM.events, id: \._id) { event in
                    EventCard(event: event)
                    
                        .onTapGesture {
                            appCoordinator.push(.eventDetailView(named: event))
                        }
                }
            }
            //  }
        }
    }
}
