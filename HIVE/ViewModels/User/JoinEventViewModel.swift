//
//  JoinEventViewModel.swift
//  HIVE
//
//  Created by Akito Daiki on 24/10/2024.
//

import Foundation

class JoinEventViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil

    func joinEvent(eventId: String, token: String) {
        let joinEvent = JoinEvent(eventId: eventId)
        isLoading = true
        errorMessage = nil
        successMessage = nil

        joinEvent.execute(getMethod: "POST", token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.success {
                        self?.successMessage = "Successfully joined the event!"
                    } else {
                        self?.errorMessage = response.message
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to join event: \(error.localizedDescription)"
                }
            }
        }
    }
}
