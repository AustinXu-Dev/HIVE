//
//  GetOneUserViewModel.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

class GetOneUserByIdViewModel: ObservableObject {
    
    @Published var userDetail: UserDetails? = nil
    @Published var errorMessage: String? = nil
    
    func getOneUserById(id: String) {
        errorMessage = nil
        let getOneUser = GetUserById(id: id)
        getOneUser.execute(getMethod: "GET", token: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userDetailData):
                    self.userDetail = userDetailData.message
                case .failure(let error):
                    self.errorMessage = "Failed to get user detail by id: \(error.localizedDescription)"
                }
            }
        }
    }
}
