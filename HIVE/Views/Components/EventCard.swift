//
//  EventCard.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/10/2024.
//

import SwiftUI

struct EventCard: View {
    let event : EventModel
    var body: some View {
        NavigationStack {
            VStack {
            ZStack(alignment:.topLeading) {
                Image("event")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 270)
                    .overlay(
                        TopRoundedCorners(radius: 20)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("topColor"), Color("bottomColor")]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 4
                            )
                    )
                    .clipShape(TopRoundedCorners(radius: 20))
                    .padding(.horizontal)
                
                
                
                VStack(alignment:.leading) {
                    VStack() {
                        if let eventDate = Date.stringToDate(event.startDate) {
                            Text(eventDate.toDayMonthString())
                                .foregroundStyle(Color.black)
                                .font(.system(.caption))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal,8)
                        }
                    }
                    .frame(width:42,height: 42)
                    .background(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .padding(.horizontal,40)

                    
                    
                    
                    VStack(alignment:.leading) {
                        ZStack(alignment:.bottomLeading) {
                            Rectangle()
                                .fill(
                                       LinearGradient(
                                           gradient: Gradient(colors: [      Color("themeWhite2"),Color("themeWhite")]),
                                           startPoint: .top,
                                           endPoint: .bottom
                                       )
                                       
                                   )
                            
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .padding(.horizontal,15)
                             
                            
                            VStack(alignment:.leading,spacing:4){
                                if let startTime = event.startTime.to12HourFormat() {
                                    Text("\(event.name) - \(startTime)")
                                        .foregroundStyle(Color.black)
                                        .bold()
                                        .font(.title2)
                                        .lineLimit(2)
                                }
                                HStack {
                                    Text(event.location)
                                        .foregroundStyle(Color.black)
                                        .font(.system(.headline))
                                    Spacer()
                                    ParticipantView()
                                }
                            }
                            .padding(.horizontal,40)
                            .padding(.vertical,20)

                            
                        }
                }
                    
                }
                
                
               
                
//                .padding(.horizontal,40)
                .padding(.vertical,20)
                
            }
          
        }
         
        }
    }
}

#Preview {
    EventCard(event: EventMock.instance.eventA)
       
}

struct TopRoundedCorners: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Top left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        
        // Top right corner
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(0),
                    clockwise: false)
        
        // Bottom line
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
    }
}

