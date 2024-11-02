//
//  GetOneUserViewModel.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

class GetOneUserByIdViewModel: ObservableObject {
    
    @Published var userDetail: UserModel? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading : Bool = false
    
    func getOneUserById(id: String) {
        isLoading = true
        errorMessage = nil
        let getOneUser = GetUserById(id: id)
        getOneUser.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let userDetailData):
                    self?.userDetail = userDetailData.message
                case .failure(let error):
                    self?.errorMessage = "Failed to get user detail by id: \(error.localizedDescription)"
                }
            }
        }
    }
}
