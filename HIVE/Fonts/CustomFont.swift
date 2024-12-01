//
//  CustomFont.swift
//  HIVE
//
//  Created by Austin Xu on 2024/11/8.
//

import Foundation
import SwiftUI

struct CustomFont{
    static let titleFont = "Lato-Bold"
    static let bodyFont = "Lato-Regular"
    static let boldFont = "Lato-Bold"
    static let lightFont = "Lato-Light"
    
    static let onBoardingTitle: Font = .custom(boldFont, size: 40)
    static let onBoardingSubtitle: Font = .custom(boldFont, size: 32)
    static let onBoardingDescription: Font = .custom(bodyFont, size: 16)
    static let onBoardingButton: Font = .custom(bodyFont, size: 24)
    static let onBoardingButtonFont: Font = .custom(bodyFont, size: 20)
    static let termsStyle: Font = .custom(lightFont, size: 12)
    
    static let eventTitleStyle: Font = .custom(boldFont, size: 32)
    static let eventSubtitleStyle: Font = .custom(bodyFont, size: 16)
    static let eventBodyStyle: Font = .custom(bodyFont, size: 13)
    
    static let attendeeTitle: Font = .custom(titleFont, size: 14)
    static let attendeeDescription: Font = .custom(bodyFont, size: 12)
    
    static let hostTitle: Font = .custom(boldFont, size: 12)
    static let hostDescription: Font = .custom(bodyFont, size: 10)
    static let detail: Font = .custom(boldFont, size: 10)
    
    static let successTitle: Font = .custom(titleFont, size: 24)
    static let successSubtitle: Font = .custom(bodyFont, size: 16)
    
    static let profileTitle: Font = .custom(titleFont, size: 20)
    static let aboutStyle: Font = .custom(bodyFont, size: 10)
    static let bioStyle: Font = .custom(bodyFont, size: 14)
    
    static let noResultStyle: Font = .custom(bodyFont, size: 24)
    static let boxTextStyle: Font = .custom(bodyFont, size: 18)
    
    static let createEventTitle: Font = .custom(titleFont, size: 18)
    static let createEventSubtitle: Font = .custom(titleFont, size: 14)
    static let createEventSubBody: Font = .custom(bodyFont, size: 16)
    static let createEventBody: Font = .custom(bodyFont, size: 14)
    
    
    static let pendingParticipantBoldText: Font = .custom(titleFont, size: 14)
    static let pendindParticipantText: Font = .custom(bodyFont, size: 14)
  
  static let eventRowEventTitle: Font = .custom("Inter-Medium", size: 20)
  static let eventRowEventDate: Font =  .custom("Inter-Bold", size: 14)
}
