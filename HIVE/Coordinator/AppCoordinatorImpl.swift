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
  @Published var selectedTabIndex: Tab = .home
    
    // MARK: - Navigation Functions
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
  
  func setSelectedTab(index: Tab) {
    print("Select tab index \(selectedTabIndex)")
    selectedTabIndex = index
  }
    
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .signIn:
            SignInView()
        case .onBoarding:
            OnboardingView()
        case .faceVerification:
            FaceVerificationView()
        case .imageCapture:
            ImageCaptureView()
        case .verifySuccess:
            FaceVerifySuccessView()
        case .home:
            TabScreenView()
        case .eventDetailView(named: let event):
            EventDetailView(event: event)
        case .eventCreationForm:
            EventCreationView()
        case .eventJoinSuccess(isPrivate: let isPrivate):
            EventJoinSuccessView(isPrivate: isPrivate)
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
        case .eventApproveRejectView:
          EventApproveRejectView()
        case .eventSchedule:
          CurrentEventScheduleView()
        case .instagram:
            ShareSocialView()
        }
    }
}
