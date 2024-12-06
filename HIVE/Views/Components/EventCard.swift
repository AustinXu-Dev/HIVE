//
//  EventCard.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/10/2024.
//

import SwiftUI
import Kingfisher
struct EventCard: View {
    let event : EventModel
    var body: some View {
        VStack {
            ZStack(alignment:.topLeading) {
                KFImage(URL(string: event.eventImageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(width: UIScreen.main.bounds.width * 0.98, height: 270) // Constrains size
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
                                        .font(CustomFont.eventTitleStyle)
                                        .lineLimit(2)
                                }
                                HStack {
                                    Text(event.location)
                                        .foregroundStyle(Color.black)
                                        .font(CustomFont.eventSubtitleStyle)
                                    Spacer()
                                    ParticipantView(event: event)
                                }
                            }
                            .padding(.horizontal,40)
                            .padding(.vertical,20)
                            
                            
                        }
                    }
                }
                .padding(.vertical,20)
                
            }
        }
      
        .frame(width: UIScreen.main.bounds.width * 0.98) // Constrain the card width
    }
}

#Preview {
    EventCard(event: EventMock.instance.eventA)
    
}

struct TopRoundedCorners: Shape {
    var radius: CGFloat
    var horizontalPadding: CGFloat = 15
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Adjusting for horizontal padding
        let adjustedMinX = rect.minX + horizontalPadding
        let adjustedMaxX = rect.maxX - horizontalPadding
        
        // Top left corner
        path.move(to: CGPoint(x: adjustedMinX, y: rect.maxY))
        path.addLine(to: CGPoint(x: adjustedMinX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: adjustedMinX + radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        
        // Top right corner
        path.addLine(to: CGPoint(x: adjustedMaxX - radius, y: rect.minY))
        path.addArc(center: CGPoint(x: adjustedMaxX - radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(0),
                    clockwise: false)
        
        // Bottom line
        path.addLine(to: CGPoint(x: adjustedMaxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: adjustedMinX, y: rect.maxY))
        
        return path
    }
}

