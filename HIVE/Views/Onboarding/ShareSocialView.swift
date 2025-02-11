//
//  ShareSocialView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import SwiftUI
import FirebaseAuth

struct ShareSocialView: View {
    
    @State private var isValid: Bool? = nil
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var viewModel: OnboardingViewModel
    @EnvironmentObject var googleVM: GoogleAuthenticationViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .all)
            VStack{
                VStack(alignment: .leading) {
                    Text("Connect easily")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .heading2()
                    Text("Share your Instagram so others can reach out!")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .body6()
                        .padding(.bottom, 50)
                    
                    TextField("Paste your instagram link here", text: $viewModel.instagramHandle)
                        .onChange(of: viewModel.instagramHandle, { oldValue, newValue in
                            validateLink()
                        })
                        .light6()
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20)
                            .stroke(isValid == true ? Color.green : (isValid == false ? Color.red : Color.gray), lineWidth: 2)
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                    
                    if isValid == false {
                        Text("Invalid link! Please enter a valid Instagram profile link.")
                            .foregroundColor(.red)
                            .light6()
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Spacer(minLength: 0)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 250, height: 50)
                    .overlay {
                        Text("Done")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .heading4()
                    }
                    .onTapGesture {
                        // MARK: - Go to Home
                        // if instagram link valid, post the instagram link to backend
                        if isValid == true{
//                            print("instagram link valid")
//                            signupVM.name = viewModel.name
//                            signupVM.dateOfBirth = formatDate(viewModel.birthday)
//                            signupVM.gender = viewModel.gender.rawValue
//                            signupVM.profileImageUrl = viewModel.profileImageURL ?? ""
//                            signupVM.bio = viewModel.bio
//                            signupVM.about = viewModel.bioType?.rawValue ?? ""
//                            signupVM.email = Auth.auth().currentUser?.email ?? ""
//                            signupVM.password = Auth.auth().currentUser?.uid ?? ""
//                            
//                            print("In View Model", viewModel.name,viewModel.instagramHandle)
//                            print("In signup view model", signupVM.name, signupVM.dateOfBirth)
//                            signupVM.signUp()
//                            
//                            showFaceVerification = true
                            appCoordinator.push(.faceVerification)
                        }
                    }
                
            }
        }
        .onTapGesture {
            print("On tap social view")
            isFocused = false
            UIApplication.shared.endEditing()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Skip"){
                    //MARK: - Post to backend without instagram link
//                    signupVM.name = viewModel.name
//                    signupVM.dateOfBirth = formatDate(viewModel.birthday)
//                    signupVM.gender = viewModel.gender.rawValue
//                    signupVM.profileImageUrl = viewModel.profileImageURL ?? ""
//                    signupVM.bio = viewModel.bio
//                    signupVM.about = viewModel.bioType?.rawValue ?? ""
//                    signupVM.email = Auth.auth().currentUser?.email ?? ""
//                    signupVM.password = Auth.auth().currentUser?.uid ?? ""
//                    signupVM.signUp()
//                    
//                    signupVM.instagramLink = ""
//                    showFaceVerification = true
                    viewModel.instagramHandle = ""
                    appCoordinator.push(.faceVerification)
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
    
    // Function to validate Instagram profile link
    private func validateLink() {
        // Regular expression for Instagram profile URL (web and mobile)
        let profileRegex = #"^https?://(www\.)?instagram\.com/([a-zA-Z0-9._]+)(/?)(\?.*)?$"#
        
        // Check if the URL matches the regular expression
        if let _ = viewModel.instagramHandle.range(of: profileRegex, options: .regularExpression) {
            isValid = true
        } else {
            isValid = false
        }
    }
    
}

#Preview {
    ShareSocialView()
}
