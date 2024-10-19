//
//  OnboardingView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject var viewModel = OnboardingViewModel()
    @State var currentStep: Int = 0
    @State var showHome: Bool = false
    @State var showInsta: Bool = false
    
    let onboardingSteps: [OnboardingStep] = [
        OnboardingStep(title: "Let's get started!", description: "Please enter your first name", type: .Name),
        OnboardingStep(title: "Hey! When is your birthday?", description: "", type: .Birthday),
        OnboardingStep(title: "What's your gender?", description: "", type: .Gender),
        OnboardingStep(title: "Time to shine!", description: "Add a profile picture so others can see who's attending.", type: .Pfp),
        OnboardingStep(title: "Tell me more about you.", description: "What brings you to bangkok?", type: .SelfInfo)
        
    ]
    
    var body: some View {
        ZStack{
            if showHome{
                ContentView()
                    
            } else if showInsta{
                ShareSocialView(showHome: $showHome)
                    .onAppear {
                        print("Image", viewModel.profileImageURL!)
                    }
            } else {
                VStack{
                    BarProgressView(steps: onboardingSteps.count, currentStep: $currentStep)
                    OnboardingDetailView(onboardingSteps: onboardingSteps, currentStep: currentStep, viewModel: viewModel)
                    Spacer()
                    ContinueButton(currentStep: $currentStep) {
                        
                        if currentStep == onboardingSteps.firstIndex(where: { $0.type == .Pfp }) {
                            if viewModel.profileImageURL == nil {
                                // Show an alert or prevent the user from continuing if the image is not uploaded
                                print("Please upload a profile picture before proceeding.")
                            } else {
                                // Proceed to the next step
                                if currentStep < onboardingSteps.count - 1 {
                                    currentStep += 1
                                } else {
                                    withAnimation(.linear.delay(0.5)) {
                                        showInsta = true
                                    }
                                }
                            }
                        } else {
                            if currentStep < onboardingSteps.count - 1{
                                currentStep += 1
                            } else {
                                withAnimation(.linear.delay(0.5)){
                                    showInsta = true
                                }
                            }
                        }
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    OnboardingView()
}

