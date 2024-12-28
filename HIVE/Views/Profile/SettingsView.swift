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
                                profileEditVM.isEditingProfileImage = true
                                profileEditVM.isEditingDescription = true
                                dismiss()
                            }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    
                    NavigationLink(destination: BlockedUsersView()) {
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
                }
                
                LineView()
                
                Group {
                    NavigationLink(destination: BlockedUsersView()) {
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
                    }
                    
                    NavigationLink(destination: BlockedUsersView()) {
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
                }
                
                
                Button(action: {
                  
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

