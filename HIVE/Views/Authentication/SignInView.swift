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

    
    var body: some View {

        if isNew {
            OnboardingView()
            .onAppear {
              print("app state \(userAppState)")
            }
        } else {
            VStack(alignment: .center){
                Text("Welcome!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(CustomFont.onBoardingTitle)
                Text("Find your next meepup tonight!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(CustomFont.onBoardingDescription)
                Button {
                    googleVM.signInWithGoogle(presenting: Application_utility.rootViewController) { error, isNewUser in
                        isNew = isNewUser
                    }
                } label: {
                    Image("continue_with_google")
                }.padding(.top, 40)
                
                Spacer()
                

                
                Button {
                  userAppState = AppState.guest.rawValue
                } label: {
                    Text("Browse First")
                        .underline(true, color: .black)
                        .font(CustomFont.onBoardingButtonFont)
                }.foregroundStyle(.black)
                    .padding(.bottom, 20)
                
                Text("By signing up you agree with terms of services of Hive.")
                    .font(CustomFont.termsStyle)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .navigationBarBackButtonHidden(true)
            .onAppear {
              print("app state \(userAppState)")
            }
        }
            
    }
       
        
}

#Preview {
    SignInView()
}
