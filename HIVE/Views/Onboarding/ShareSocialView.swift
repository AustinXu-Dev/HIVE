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
    @EnvironmentObject var viewModel: OnboardingViewModel
    @EnvironmentObject var googleVM: GoogleAuthenticationViewModel
    @ObservedObject var signupVM = SignUpService()
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text("Connect easily")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                Text("Share your Instagram so others can reach out!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3)
                    .padding(.bottom, 50)
                
                TextField("Paste your instagram link here", text: $viewModel.instagramHandle)
                    .onChange(of: viewModel.instagramHandle, { oldValue, newValue in
                        validateLink()
                    })
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20)
                        .stroke(isValid == true ? Color.green : (isValid == false ? Color.red : Color.gray), lineWidth: 2)
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if isValid == false {
                    Text("Invalid link! Please enter a valid Instagram profile link.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 250, height: 50)
                .overlay {
                    Text("Done")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                .onTapGesture {
                    // MARK: - Go to Home
                    // if instagram link valid, post the instagram link to backend
                    if isValid == true{
                        print("instagram link valid")
                        signupVM.name = viewModel.name
                        signupVM.dateOfBirth = formatDate(viewModel.birthday)
                        signupVM.gender = viewModel.gender.rawValue
                        signupVM.profileImageUrl = viewModel.profileImageURL ?? ""
                        signupVM.bio = viewModel.bio
                        signupVM.about = viewModel.bioType?.rawValue ?? ""
                        signupVM.instagramLink = viewModel.instagramHandle
                        signupVM.email = Auth.auth().currentUser?.email ?? ""
                        signupVM.password = Auth.auth().currentUser?.uid ?? ""
                        
                        print("In View Model", viewModel.name,viewModel.instagramHandle)
                        print("In signup view model", signupVM.name, signupVM.dateOfBirth)
                        signupVM.signUp()
                    }
//                    print("instagram link not valid")
                }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip"){
                        //MARK: - Post to backend without instagram link
                        signupVM.name = viewModel.name
                        signupVM.dateOfBirth = formatDate(viewModel.birthday)
                        signupVM.gender = viewModel.gender.rawValue
                        signupVM.profileImageUrl = viewModel.profileImageURL ?? ""
                        signupVM.bio = viewModel.bio
                        signupVM.about = viewModel.bioType?.rawValue ?? ""
                        signupVM.instagramLink = ""
                        signupVM.email = Auth.auth().currentUser?.email ?? ""
                        signupVM.password = Auth.auth().currentUser?.uid ?? ""
                        signupVM.signUp()
                    }
                }
            }
        }
        
    }
    
    func formatDate(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // Function to validate Instagram profile link
    private func validateLink() {
        // Regular expression for Instagram profile URL
        let profileRegex = #"^https://(www\.)?instagram\.com/([a-zA-Z0-9._]+)(/)?$"#
        
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
