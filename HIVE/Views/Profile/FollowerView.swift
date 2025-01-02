//
//  FollowerView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 11/12/2567 BE.
//

import SwiftUI
import Kingfisher


struct FollowerView: View {
    @State private var searchText = ""
    @State private var hasResults = true
    @State private var isFollowingTabSelected = true
  var followings: [UserModel]
  var followers:   [UserModel]
  var currentUser: UserModel
  @EnvironmentObject var appCoordinator: AppCoordinatorImpl


  var filteredUsers: [UserModel] {
    let list = isFollowingTabSelected ? followings : followers

        if searchText.isEmpty {
            return list
        } else {
            let results = list.filter { performSearch(for: searchText, in: $0) }
            hasResults = !results.isEmpty
            return results
        }
    }

    var body: some View {

            VStack {
                HStack {
                    Button(action: {
                        isFollowingTabSelected = true
                        searchText = ""
                        hasResults = true
                    }) {
                        VStack(spacing: 5) {
                          Text("\(followings.count) Following")
                                .body4()
                                .fontWeight(.bold)
                                .foregroundColor(isFollowingTabSelected ? .black : .gray)
                            Rectangle()
                                .frame(width: 128, height: 1)
                                .foregroundColor(isFollowingTabSelected ? .black : .clear)
                        }
                        .padding(.leading, 23)
                    }

                    Spacer()

                    Button(action: {
                        isFollowingTabSelected = false
                        searchText = ""
                        hasResults = true
                    }) {
                        VStack(spacing: 5) {
                          Text("\(followers.count) Followers")
                                .body4()
                                .fontWeight(.bold)
                                .foregroundColor(!isFollowingTabSelected ? .black : .gray)
                            Rectangle()
                                .frame(width: 128, height: 1)
                                .foregroundColor(!isFollowingTabSelected ? .black : .clear)
                        }
                    }
                    .padding(.trailing, 23)
                }
                .padding()

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                        .padding(.leading, 10)

                    TextField("Search for user", text: $searchText)
                        .padding(10)
                        .onChange(of: searchText) { _ in
                            _ = filteredUsers
                        }

                    Spacer()
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.horizontal, 16)

                if hasResults {
                  ForEach(filteredUsers,id: \._id){ user in
                        HStack {
                          KFImage(URL(string: user.profileImageUrl ?? "" ))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                              Text(user.name ?? "")
                                    .heading7()
                              Text(user.bio ?? "")
                                    .light6()
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal,6)
                        .background(Color.white.opacity(0.00001))
                        .onTapGesture {
                          appCoordinator.push(.socialProfile(user: user))
                        }
                       // .padding(.horizontal,6)

                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    VStack {
                        Text("No results found")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity,alignment: .center)
                }
            }
            .frame(maxHeight: .infinity,alignment: .top)
            .toolbar {
                ToolbarItem(placement: .principal) {
                  HStack {
                      Text(currentUser.name ?? "")
                        .font(.headline)
                      if currentUser.verificationStatus == VertificationEnum.approved.rawValue {
                        Image(systemName: "checkmark.seal.fill")
                          .aspectRatio(contentMode: .fit)
                          .frame(width:20,height:20)
                          .foregroundColor(.blue)
                      }
                    
                  }
                }
            }
            .onTapGesture {
                dismissKeyboard()
            }
          
        
    }

    func performSearch(for query: String, in user: UserModel) -> Bool {
        let lowercasedQuery = query.lowercased()
        let userName = user.name?.lowercased()
      let userDescription = user.bio?.lowercased()

      return ((userName?.contains(lowercasedQuery)) != nil) || ((userDescription?.contains(lowercasedQuery)) != nil)
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



