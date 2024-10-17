//
//  OnboardingViewModel.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    // Published properties for each data point to be filled in the onboarding flow
    @Published var name: String = ""
    @Published var birthday: Date = Date()
    @Published var gender: Gender = .diverse
    @Published var profileImage: UIImage? = nil
    @Published var bioType: Set<BioType> = []
    @Published var bio: String = ""
    @Published var instagramHandle: String = ""
}
