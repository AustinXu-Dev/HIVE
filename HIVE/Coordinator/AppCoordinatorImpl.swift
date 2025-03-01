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
        case .eventDetailView(named: let event,comesFromHome: let comesFromHome):
            EventDetailView(event: event,comesFromHome: comesFromHome)
        case .eventCreationForm:
            EventCreationView()
        case .eventJoinSuccess(isPrivate: let isPrivate):
            EventJoinSuccessView(isPrivate: isPrivate)
        case .eventAttendeeView(named: let event, comesFromHome: let comesFromHome):
            EventAttendeeView(event: event, comesFromHome: comesFromHome)
        case .tab:
            TabScreenView()
        case .eventCreationSuccess:
            EventCreationSuccessView()
//        case .participantOrOrganizerProfile(named: let user):
//          ParticipantProfile(user : user)
        case .eventApproveRejectView:
          EventApproveRejectView()
        case .eventSchedule:
          CurrentEventScheduleView()
        case .instagram:
            ShareSocialView()
        case .followerView(followingsSocial: let followings, follwersSocial: let followers, currentUser: let currentUser):
          FollowerView(followings: followings, followers: followers, currentUser: currentUser)
        case .socialProfile(user: let user):
          SocialProfile(social: user)
        }
    }
}
