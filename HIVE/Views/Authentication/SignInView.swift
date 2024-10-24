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
    
    var body: some View {
        
        if isNew{
            OnboardingView()
        } else {
            VStack(alignment: .center){
                Text("Welcome!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                Text("Find your next meepup tonight!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3)
                Button {
                    googleVM.signInWithGoogle(presenting: Application_utility.rootViewController) { error, isNewUser in
                        isNew = isNewUser
                    }
                } label: {
                    Image("continue_with_google")
                }.padding(.top, 40)
                
                Spacer()
                
                Button {
                    appCoordinator.push(.home)
                } label: {
                    Text("Browse First")
                        .underline(true, color: .black)
                }.foregroundStyle(.black)
                    .padding(.bottom, 20)
                
                Text("By signing up you agree with terms of services of Hive.")
                    .font(.caption)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .navigationBarBackButtonHidden(true) 
        }
            
    }
       
        
}

#Preview {
    SignInView()
}
