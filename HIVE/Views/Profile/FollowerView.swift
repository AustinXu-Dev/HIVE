//
//  FollowerView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 11/12/2567 BE.
//

import SwiftUI

struct DemoUser: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let image: String
}

struct FollowerView: View {
    @State private var searchText = ""
    @State private var hasResults = true
    @State private var isFollowingTabSelected = true

    let following: [DemoUser] = [
        DemoUser(name: "Rose", description: "Hi I’m rose, hope we get along 🙌", image: "person.circle"),
        DemoUser(name: "Lewis", description: "Hi I’m lewis, I’m the 8-time world champion 🏆🐐", image: "person.circle"),
        DemoUser(name: "Jennie", description: "Hi I’m jennie, hope we get along 🙌", image: "person.circle"),
    ]

    let followers: [DemoUser] = [
        DemoUser(name: "Alex", description: "I’m Alex. Let’s connect! ✨", image: "person.circle"),
        DemoUser(name: "Taylor", description: "I’m Taylor, happy to be here!", image: "person.circle"),
        DemoUser(name: "Chris", description: "Hey, I’m Chris. Nice to meet you! 👋", image: "person.circle"),
    ]

    var filteredUsers: [DemoUser] {
        let list = isFollowingTabSelected ? following : followers
        if searchText.isEmpty {
            return list
        } else {
            let results = list.filter { performSearch(for: searchText, in: $0) }
            hasResults = !results.isEmpty
            return results
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        isFollowingTabSelected = true
                        searchText = ""
                        hasResults = true
                    }) {
                        VStack(spacing: 5) {
                            Text("\(following.count) Following")
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

                // User List or No Results Message
                if hasResults {
                    List(filteredUsers) { user in
                        HStack {
                            Image(systemName: user.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    VStack {
                        Spacer()
                        Text("No results found")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Lebron")
                            .font(.headline)
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }

    func performSearch(for query: String, in user: DemoUser) -> Bool {
        let lowercasedQuery = query.lowercased()
        let userName = user.name.lowercased()
        let userDescription = user.description.lowercased()

        return userName.contains(lowercasedQuery) || userDescription.contains(lowercasedQuery)
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    FollowerView()
}

