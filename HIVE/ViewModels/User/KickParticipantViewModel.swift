//
//  KickParticipantViewModel.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 10/12/2567 BE.
//

import Foundation

class KickParticipantViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil
    @Published var kickSuccess : Bool = false

    func kickParticipants(eventId: String, participantId: String, token: String) {
        let kickParticipant = KickParticipants(eventId: eventId, participantId: participantId)
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        kickParticipant.execute(getMethod: "POST", token: token) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let success):
                    self.successMessage = "Successfully kicked the participant."
                    self.kickSuccess = true
                    print("Successfully Kicked")
                case .failure(let failure):
                    self.errorMessage = "Failed to kick participant: \(failure.localizedDescription)"
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    
}
