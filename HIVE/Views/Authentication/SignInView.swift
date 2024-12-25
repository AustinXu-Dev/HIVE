//
//  SignInView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var googleVM: GoogleAuthenticationViewModel
    @EnvironmentObject var viewModel: OnboardingViewModel
    @State var isNew = false
    @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue
    @State private var emailInput: String = ""
    @FocusState private var emailIsFocused: Bool
    
    @State private var passwordInput: String = ""
    @FocusState private var passwordIsFocused: Bool
    @State private var passwordIsShown: Bool = false
    @StateObject var emailSignInVM = EmailSignInViewModel()
    
    @State private var resetPasswordEmailInput:String = ""
    @State private var showErrorAlert: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        
        if isNew {
            OnboardingView()
        } else {
            ZStack {
                Color.white
                VStack(alignment: .center,spacing: 32){
                    VStack(alignment:.leading,spacing:44) {
                        header
                        BlankTextField(titleText: "Email", isValid: $emailSignInVM.emailFieldIsValid , isSecuredField: false, inputText: $emailSignInVM.email, passwordIsShown: .constant(true), errorText: $emailSignInVM.emailFieldErrorMessage, isFocused: $emailIsFocused)
                        BlankTextField(titleText: "Password", isValid: $emailSignInVM.passwordFieldIsValid, isSecuredField: true, inputText: $emailSignInVM.password, passwordIsShown: $passwordIsShown, errorText: $emailSignInVM.passwordFieldErrorMessage, isFocused: $passwordIsFocused)
                    }
                    forgetPasswordButton
                    signInButton
                        .padding(.horizontal,8)
                    divider
                    signInWithGoogleButton
                        .padding(.horizontal,8)
                    Spacer()
                    browseFirstButton
                }
                .padding()
                .padding(.top,40)
                .frame(maxWidth: .infinity)
                .navigationBarBackButtonHidden(true)
            }
            .onChange(of: emailSignInVM.isNewUser, { _, isNewUser in
                self.isNew = isNewUser
            })
            .onChange(of: emailSignInVM.password, { _, typedPassword in
                emailSignInVM.password = typedPassword
            })
            .onChange(of: emailSignInVM.errorMessage, { _, _ in
                showErrorAlert = true
            })
            .onChange(of: emailSignInVM.email, { _, typedEmail in
                withAnimation(.smooth.speed(5.0)) {
                    if emailSignInVM.email.count > 6 && emailSignInVM.email.contains(where: { $0 == "@"}) {
                        (emailSignInVM.emailFieldErrorMessage,emailSignInVM.emailFieldIsValid) = TextFieldValidationManager.validateEmail(typedEmail)
                    }
                }
            })
            .onChange(of: emailSignInVM.password, { _, typedPassword in
                if emailSignInVM.password.count > 6 {
                    withAnimation(.smooth.speed(5.0)) {
                        (emailSignInVM.passwordFieldErrorMessage,emailSignInVM.passwordFieldIsValid) = TextFieldValidationManager.validatePassword(typedPassword)
                    }
                }
            })
            //MARK: alert for email verification
            .alert("Check your email inbox", isPresented: $emailSignInVM.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(emailSignInVM.alertMessage)
            }
            //MARK: alert for password reset
            .alert("Enter your email", isPresented: $showAlert, actions: {
                TextField("Email", text: $resetPasswordEmailInput)
                Button("Submit") {
                    Task {
                        print("email is :\(resetPasswordEmailInput)")
                        await emailSignInVM.resetPassword(email: resetPasswordEmailInput)
                    }
                }
                Button("Cancel", role: .cancel) {
                    showAlert = false
                }
            }, message: {
                Text("Please enter the email address of the account that you want to reset password.")
            })
            //MARK: alert for error
            .alert("Unexpected Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {
                    showErrorAlert = false
                }
            } message: {
                Text(emailSignInVM.errorMessage ?? "Unknown Error Occured")
            }
            
            .onTapGesture {
                self.hideKeyboard()
            }
            
        }
        
    }
    
    
}

#Preview {
    SignInView(emailSignInVM: EmailSignInViewModel())
}

extension SignInView {
    private var header: some View {
        VStack {
            Text("Welcome to Hive!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .heading1()
            Text("Discover new friends and Bangkok's best spots.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .body7()
        }
    }
    
    private var signInWithGoogleButton: some View {
        Button {
            googleVM.signInWithGoogle(presenting: Application_utility.rootViewController) { error, isNewUser in
                isNew = isNewUser
            }
        } label: {
            Image("continue_with_google_text")
                .padding(.vertical, 6)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
        )

    }
    
    private var forgetPasswordButton: some View {
        HStack {
            if emailSignInVM.isWaitingForVerification && emailSignInVM.hasWaiting3Mintutes {
                Button {
                    Task {
                        await emailSignInVM.sendEmailVerification()
                    }
                } label: {
                    Text("Resend verification mail")
                        .heading9()
                        .foregroundStyle(Color.blue)
                }
            }
            Spacer()
            Button {
                showAlert = true
            } label: {
                Text("Forgot password?")
                    .heading9()
                    .foregroundStyle(Color.black)
            }
        }
    }
    
    private var signInButton: some View {
        Button {
            withAnimation(.smooth.speed(5.0)) {
                (emailSignInVM.emailFieldErrorMessage,emailSignInVM.emailFieldIsValid) = TextFieldValidationManager.validateEmail(emailSignInVM
                    .email)
                (emailSignInVM.passwordFieldErrorMessage,emailSignInVM.passwordFieldIsValid) = TextFieldValidationManager.validatePassword(emailSignInVM.password)
            }
            if emailSignInVM.emailFieldIsValid && emailSignInVM.passwordFieldIsValid {
                Task {
                    await emailSignInVM.handleAuthentication()
                }
            }
        } label: {
            Text("Sign up/Log in")
                .heading5()
                .bold()
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .padding(.horizontal)
                .padding(.vertical,12)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity)
                }
        }
    }
    
    private var divider: some View {
        HStack {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height:1)
            Text("Or")
                .body4()
                .fontWeight(.medium)
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height:1)
        }
    }
    
    private var browseFirstButton: some View {
        Button {
            userAppState = AppState.guest.rawValue
        } label: {
            Text("Browse First")
                .underline(true, color: .black)
                .body4()
        }.foregroundStyle(.black)
            .padding(.bottom, 20)
    }
}
