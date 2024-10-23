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

    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                KFImage(URL(string: event.eventImageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
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
                        ParticipantView()
                        .onTapGesture {
                            if let participants = event.participants {
                                appCoordinator.push(.eventAttendeeView(named: event))
                            }
                        }
//                        Image("profile")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                            .clipShape(Circle())
//                            .offset(x: 10)
//                        Image("profile")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                            .clipShape(Circle())
//                            .offset(x: -10)
//                    }
//                    
//                    Text("18/20")
//                        .font(.subheadline)
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
                        Image("profile")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(event.organizer)
                                .fontWeight(.bold)
                            Text("Outgoing expat who loves nightlife 🌃")
                                .font(.subheadline)
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
                
                VStack {
                    Spacer()
                    

                    Button(action: {
                        /// TO DO
                        //MARK: POST Event Join and custom Animation to be added
                        print("Join button tapped!")
                        appCoordinator.push(.eventJoinSuccess)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.purple, lineWidth: 5)
                                .shadow(color: Color.purple.opacity(0.4), radius: 20, x: 0, y: 0)
                                .shadow(color: Color.purple.opacity(0.4), radius: 40, x: 0, y: 0)
                                .frame(width: 300, height: 60)
                                .overlay {
                                    Text("Join")
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
                    
                    Spacer()
                }
                .padding()
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitle("Back", displayMode: .inline)
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
        HStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
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
            }
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
