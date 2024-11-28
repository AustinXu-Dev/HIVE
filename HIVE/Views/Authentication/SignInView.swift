//
//  SignInView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import SwiftUI

struct SignInView: View {
  @EnvironmentObject var appCoordinator: AppCoordinatorImpl
  @ObservedObject var googleVM = GoogleAuthenticationViewModel()
  @State var isNew = false
  @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue
  @State private var emailInput: String = ""
  @FocusState private var emailIsFocused: Bool
  
  @State private var passwordInput: String = ""
  @FocusState private var passwordIsFocused: Bool
  @State private var passwordIsShown: Bool = false
  
  
  var body: some View {
    
    if isNew {
      OnboardingView()
    } else {
      ZStack {
        Color.white
        VStack(alignment: .center,spacing: 32){
          VStack(alignment:.leading,spacing:44) {
            header
            BlankTextField(titleText: "Email", isValid: true, isSecuredField: false, inputText: $emailInput, passwordIsShown: .constant(true), errorText: .constant(""), isFocused: $emailIsFocused)
            
            BlankTextField(titleText: "Password", isValid: true, isSecuredField: true, inputText: $passwordInput, passwordIsShown: $passwordIsShown, errorText: .constant(""), isFocused: $passwordIsFocused)
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
      .onTapGesture {
        self.hideKeyboard()
      }
    }
    
  }
  
  
}

#Preview {
  SignInView()
}

extension SignInView {
  private var header: some View {
    VStack {
      Text("Welcome to Hive!")
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(CustomFont.onBoardingTitle)
      Text("Discover new friends and Bangkok's best spots.")
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(CustomFont.onBoardingDescription)
    }
  }
  
  private var signInWithGoogleButton: some View {
    Button {
      googleVM.signInWithGoogle(presenting: Application_utility.rootViewController) { error, isNewUser in
        isNew = isNewUser
      }
    } label: {
          Image("continue_with_google")
    }
  }
  
  private var forgetPasswordButton: some View {
    HStack {
      Spacer()
      Button {
        print("Forget password clicked")
      } label: {
        Text("Forgot password?")
          .font(.caption)
          .foregroundStyle(Color.black)
      }
    }
  }
  
  private var signInButton: some View {
    Button {
      print("")
    } label: {
      Text("Sign up/Log in")
        .font(.headline)
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
        .font(.headline)
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
        .font(CustomFont.onBoardingButtonFont)
    }.foregroundStyle(.black)
      .padding(.bottom, 20)
  }
}
