//
//  AppCoordinatorImpl.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation
import SwiftUI

class AppCoordinatorImpl: AppCoordinatorProtocol {
    @Published var path: NavigationPath = NavigationPath()
//    @Published var sheet: Sheet?
//    @Published var fullScreenCover: FullScreenCover?
    
    // MARK: - Navigation Functions
    func push(_ screen: Screen) {
        path.append(screen)
    }
//    
//    func presentSheet(_ sheet: Sheet) {
//        self.sheet = sheet
//    }
//    
//    func presentFullScreenCover(_ fullScreenCover: FullScreenCover) {
//        self.fullScreenCover = fullScreenCover
//    }
//    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
//    func dismissSheet() {
//        self.sheet = nil
//    }
//    
//    func dismissFullScreenOver() {
//        self.fullScreenCover = nil
//    }
    
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .signIn:
            SignInView()
        case .onBoarding:
            OnboardingView()
        case .home:
            TabScreenView()
        case .eventDetailView(named: let event):
            EventDetailView(event: event)
        case .eventCreationForm:
            EventCreationView()
        case .eventJoinSuccess:
            EventJoinSuccessView()
        case .eventAttendeeView(named: let event):
            EventAttendeeView(event: event)
        case .tab:
            TabScreenView()
        case .eventCreationSuccess:
            EventCreationSuccessView()
        case .participantProfile(named: let participant):
          ParticipantProfile(participant : participant)
        case .organizerProfile(named: let organizer):
          OrganizerProfile(organizer: organizer)
        }
    }
    
//    @ViewBuilder
//    func build(_ sheet: Sheet) -> some View {
//        switch sheet {
//        case .detailTask(named: let task):
//            DetailTaskView(task: task)
//        }
//    }
//    
//    @ViewBuilder
//    func build(_ fullScreenCover: FullScreenCover) -> some View {
//        switch fullScreenCover {
//        case .addHabit(onSaveButtonTap: let onSaveButtonTap):
//            AddHabitView(onSaveButtonTap: onSaveButtonTap)
//        }
//    }
}
