//
//  NavigationEnum.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation

enum Screen: Identifiable, Hashable {
  
  
  case signIn
  case onBoarding
  case instagram
  case faceVerification
  case imageCapture
  case verifySuccess
  case home
  case tab
  case eventDetailView(named : EventModel)
  case eventCreationForm
  case eventCreationSuccess
  case eventJoinSuccess(isPrivate: Bool)
  case eventAttendeeView(named : EventModel)
  case eventApproveRejectView
  case followerView(followingsSocial: [UserModel], follwersSocial: [UserModel], currentUser:UserModel)
  case eventSchedule
  case socialProfile(user: UserModel)
  
  var id: Self { return self }
}

enum Tab : Hashable {
  case home
  case search
  case hostEvent
  case chat
  case profile
}

//enum Sheet: Identifiable, Hashable {
////    case detailTask(named: Task)
//
//    var id: Self { return self }
//}

//enum FullScreenCover: Identifiable, Hashable {
////    case addHabit(onSaveButtonTap: ((Habit) -> Void))
//
//    var id: Self { return self }
//}
//
//extension FullScreenCover {
//    // Conform to Hashable
//    func hash(into hasher: inout Hasher) {
//        switch self {
//        case .addHabit:
//            hasher.combine("addHabit")
//        }
//    }
//
//    // Conform to Equatable
//    static func == (lhs: FullScreenCover, rhs: FullScreenCover) -> Bool {
//        switch (lhs, rhs) {
//        case (.addHabit, .addHabit):
//            return true
//        }
//    }
//}
