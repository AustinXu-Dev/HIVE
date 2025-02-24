//
//  FaceVerifySuccessView.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 11/12/2567 BE.
//

import SwiftUI
import FirebaseAuth

struct FaceVerifySuccessView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var viewModel: OnboardingViewModel
    @EnvironmentObject var googleVM: GoogleAuthenticationViewModel
    @EnvironmentObject var signupVM: SignUpService
    
    @State private var isLoading = false
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                
                Image("done_icon")
                    .padding(.bottom, 20)
                
                Text("Thanks!")
                    .heading1()
                    .padding(.bottom, 10)
                
                Text("We'll review and verify your profile within 3 days.")
                    .body4()
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Spacer()
                
                BlackButton(text: "Done", color: .constant(.black)) {
                    isLoading = true
                    viewModel.uploadVerificationIamge(uid: Auth.auth().currentUser?.uid ?? "", email: Auth.auth().currentUser?.email ?? "") {
                        print("Verification image url here: ", viewModel.verficationImageURL ?? "")
                        signupVM.name = viewModel.name
                        signupVM.dateOfBirth = formatDate(viewModel.birthday)
                        signupVM.gender = viewModel.gender.rawValue
                        signupVM.profileImageUrl = viewModel.profileImageURL ?? ""
                        signupVM.instagramLink = viewModel.instagramHandle
                        signupVM.bio = viewModel.bio
                        signupVM.about = viewModel.bioType?.rawValue ?? ""
                        signupVM.email = Auth.auth().currentUser?.email ?? ""
                        signupVM.password = Auth.auth().currentUser?.uid ?? ""
                        signupVM.verificationImageUrl = viewModel.verficationImageURL ?? ""
                        
                        signupVM.signUp()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            isLoading = false
                            appCoordinator.popToRoot()
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            
            if viewModel.isUploading && isLoading{
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                ProgressView("Processing...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back"){
                    appCoordinator.pop()
                }
                .body6()
                .foregroundStyle(.black)
            }
        }
    }
    
    func verifyAction() -> Void {
        signupVM.name = viewModel.name
        signupVM.dateOfBirth = formatDate(viewModel.birthday)
        signupVM.gender = viewModel.gender.rawValue
        signupVM.profileImageUrl = viewModel.profileImageURL ?? ""
        signupVM.instagramLink = viewModel.instagramHandle
        signupVM.bio = viewModel.bio
        signupVM.about = viewModel.bioType?.rawValue ?? ""
        signupVM.email = Auth.auth().currentUser?.email ?? ""
        signupVM.password = Auth.auth().currentUser?.uid ?? ""
        
        signupVM.verificationImageUrl = viewModel.verficationImageURL ?? ""
        
        signupVM.signUp()
    }
    
    func formatDate(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
}

#Preview {
    FaceVerifySuccessView()
}
