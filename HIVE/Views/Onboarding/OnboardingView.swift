//
//  OnboardingView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct OnboardingView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var googleVM: GoogleAuthenticationViewModel
    @EnvironmentObject var viewModel: OnboardingViewModel
    @State var currentStep: Int = 0
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @FocusState private var isFocused: Bool
    
    let onboardingSteps: [OnboardingStep] = [
        OnboardingStep(title: "Let's get started!", description: "Please enter your first name", type: .Name),
        OnboardingStep(title: "Hey! When is your birthday?", description: "", type: .Birthday),
        OnboardingStep(title: "What's your gender?", description: "", type: .Gender),
        OnboardingStep(title: "Time to shine!", description: "Add a profile picture so others can see who's attending.", type: .Pfp),
        OnboardingStep(title: "Tell me more about you.", description: "What brings you to bangkok?", type: .SelfInfo)
        
    ]
    
    var body: some View {
        ZStack{
            VStack{
                HStack {
                    Button("Back") {
                        if currentStep > 0 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        }
                    }
                    .body6()
                    .foregroundStyle(.black)
                    Spacer()
                }
                .padding(.bottom, 10)
                BarProgressView(steps: onboardingSteps.count, currentStep: $currentStep)
                OnboardingDetailView(onboardingSteps: onboardingSteps, currentStep: currentStep, viewModel: viewModel, isFocused: $isFocused)
                Spacer()
                ContinueButton(currentStep: $currentStep, color: viewModel.isUploading ? .constant(.gray) : .constant(.black)) {
                    handleStepCompletion()
                }
                .disabled(viewModel.isUploading)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Input Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }.padding()
            
            //            }
        }
        .navigationBarBackButtonHidden()
        .onTapGesture {
            isFocused = false
        }
    }
    
    func handleStepCompletion() {
        if validateCurrentStep() {
            if onboardingSteps[currentStep].type == .Pfp {
                // Upload the image in the profile picture step
                if viewModel.profileImage != nil && viewModel.profileImageURL == nil{
                    viewModel.uploadProfileImage(uid: Auth.auth().currentUser?.uid ?? "", email: Auth.auth().currentUser?.email ?? "")
                }
                if viewModel.profileImageURL != nil{
                    if currentStep < onboardingSteps.count - 1 {
                        currentStep += 1
                    } else {
                        withAnimation(.linear.delay(0.5)) {
                            //                            showInsta = true
                            appCoordinator.push(.instagram)
                        }
                    }
                }
            } else {
                // For non-image steps, simply proceed to the next step
                if currentStep < onboardingSteps.count - 1 {
                    currentStep += 1
                } else {
                    withAnimation(.linear.delay(0.5)) {
                        //                        showInsta = true
                        appCoordinator.push(.instagram)
                    }
                }
            }
        }
    }
    
    func validateCurrentStep() -> Bool {
        switch onboardingSteps[currentStep].type {
        case .Name:
            if viewModel.name.isEmpty {
                alertMessage = "Please enter your name."
                showAlert = true
                return false
            }
        case .Birthday:
            // You can add more specific validation here if needed
            return true
        case .Gender:
            return true
        case .Pfp:
            if viewModel.profileImage == nil {
                alertMessage = "Please select a profile picture."
                showAlert = true
                return false
            }
        case .SelfInfo:
            if viewModel.bio.isEmpty || viewModel.bioType == nil {
                alertMessage = "Please complete your bio information."
                showAlert = true
                return false
            }
        }
        return true
    }
}

#Preview {
    OnboardingView()
}

