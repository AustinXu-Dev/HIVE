//  EventSearchView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 18/10/2567 BE.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var hasResults = true
    let demoData = ["Apple", "Banana", "Orange", "Mango", "Peach"]

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                TextField("Search", text: $searchText, onCommit: {
                    hasResults = performSearch(for: searchText)
                })
                .padding(10)

                Spacer()
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()

            Spacer()

            if !hasResults {
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)

                    Text("No Results")
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)

                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                }) {
                    Text("Be the first to host one! 🎉")
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width / 2)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }

                Spacer()
            } else {
                List {
                    ForEach(demoData.filter { $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { item in
                        Text(item)
                    }
                }
            }

            Spacer()
        }
    }

    func performSearch(for query: String) -> Bool {
        return !demoData.filter { $0.localizedCaseInsensitiveContains(query) }.isEmpty
    }
}

#Preview {
    SearchView()
}

