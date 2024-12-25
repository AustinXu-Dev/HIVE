//
//  FaceVerificationView.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 10/12/2567 BE.
//

import SwiftUI
import FirebaseAuth
import Combine
import Vision
import VisionKit

struct FaceVerificationView: View {
    
    @State private var capturedImage: UIImage? = nil
    @State private var showCaptureScreen = false
    
    @StateObject private var cameraManager = CameraManager()
    @EnvironmentObject var signupVM: SignUpService
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var viewModel: OnboardingViewModel
    @EnvironmentObject var googleVM: GoogleAuthenticationViewModel
    @State private var isLoading = false
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                
                Image("faceId_icon")
                    .padding(.bottom, 20)
                
                Text("Stand Out & Get Noticed!")
                    .heading5()
                    .padding(.bottom, 10)
                
                Text("Verified profiles are more trusted and get more attention.")
                    .body4()
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Spacer()
                
                BlackButton(text: "Verify now", color: .constant(.black)) {
                    withAnimation(.linear.delay(0.5)) {
                        appCoordinator.push(.imageCapture)
                    }
                }
                .padding(.bottom, 30)
            }
            
            if isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                ProgressView("Processing...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Skip"){
                    //MARK: - Post to backend without verification Image link, SignUp here
                    skipButtonAction()
                }
                .body6()
                .foregroundStyle(.black)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("Back"){
                    appCoordinator.pop()
                }
                .body6()
                .foregroundStyle(.black)
            }
        }
    }
    
    func skipButtonAction() -> Void{
        isLoading = true
        signupVM.name = viewModel.name
        signupVM.dateOfBirth = formatDate(viewModel.birthday)
        signupVM.gender = viewModel.gender.rawValue
        signupVM.profileImageUrl = viewModel.profileImageURL ?? ""
        signupVM.instagramLink = viewModel.instagramHandle
        signupVM.bio = viewModel.bio
        signupVM.about = viewModel.bioType?.rawValue ?? ""
        signupVM.email = Auth.auth().currentUser?.email ?? ""
        signupVM.password = Auth.auth().currentUser?.uid ?? ""
        signupVM.verificationImageUrl = ""
        
        signupVM.signUp()
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
            isLoading = false
            appCoordinator.popToRoot()
        }
    }
    
    func formatDate(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
}

#Preview {
    FaceVerificationView()
}
