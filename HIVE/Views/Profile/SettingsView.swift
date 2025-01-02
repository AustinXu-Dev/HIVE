//
//  SettingVIew.swift
//  HIVE
//
//  Created by Kelvin Gao  on 19/12/2567 BE.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var profileEditVM: ProfileEditViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showLogoutAlert = false 
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @ObservedObject var googleVM = GoogleAuthenticationViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Group {
                    LineView()
                        .padding(.top, 10)
                    
                    HStack {
                        Image(systemName: "person.circle")
                            .font(.title3)
                            .foregroundColor(.primary)
                        Text("Edit Profile")
                            .foregroundColor(.black)
                            .body4()
                            .onTapGesture {
                                profileEditVM.isEditingProfileImage = false
                                profileEditVM.isEditingDescription = false
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    profileEditVM.isEditingProfileImage = true
                                    profileEditVM.isEditingDescription = true
                                }
                                
                                // Dismiss SettingsView
                                dismiss()
                            }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                                .font(.title3)
                                .foregroundColor(.primary)
                            Text("Blocked Users")
                                .foregroundColor(.black)
                                .body4()
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    
                }
               
                LineView()
                
                Group {
                
                        HStack {
                            Image(systemName: "lock.circle")
                                .font(.title3)
                                .foregroundColor(.primary)
                            Text("Privacy Policy")
                                .foregroundColor(.black)
                                .body4()
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    
                    
             
                        HStack {
                            Image(systemName: "doc.text")
                                .font(.title3)
                                .foregroundColor(.primary)
                            Text("Terms of Service")
                                .foregroundColor(.black)
                                .body4()
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    
                }
                
                Button(action: {                  
                    showLogoutAlert = true
                }) {
                    Text("Log out")
                        .font(.body)
                        .bold()
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .alert("Are you sure you want to logout?", isPresented: $showLogoutAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Logout", role: .destructive) {
                        googleVM.signOutWithGoogle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            appCoordinator.setSelectedTab(index: .home)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitle("Settings", displayMode: .large)
        }
    }
}

struct LineView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(1))
            .frame(height: 2)
    }
}

struct EditProfileView: View {
    var body: some View {
        Text("Edit Profile")
            .navigationTitle("Edit Profile")
    }
}

struct BlockedUsersView: View {
    var body: some View {
        Text("Blocked Users")
            .navigationTitle("Blocked Users")
    }
}


