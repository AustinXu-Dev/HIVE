//
//  OnboardingEnum.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation

// Enum for gender options
enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case diverse = "Diverse"
}

// Enum for location type
enum BioType: String, CaseIterable {
    case locall = "Local"
    case travelling = "Travelling"
    case newInTown = "New in Town"
    case expat = "Expat"
}

enum OnboardingType{
    case Name
    case Birthday
    case Gender
    case Pfp
    case SelfInfo
}
