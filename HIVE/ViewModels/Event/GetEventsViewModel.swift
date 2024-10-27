//
//  GetEventsViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import Foundation


class GetEventsViewModel : ObservableObject {
    
    //MARK: - replace the mock data with data returned from server later on
    @Published var events : [EventModel] = []
    @Published var isLoading : Bool = false
    @Published var errorMessage : String? = nil
    
       

    
    private let getAllEvents = GetAllEvents()
       
       func fetchEvents() {
           isLoading = true
           getAllEvents.execute(token: nil) { [weak self] result in
               switch result {
               case .success(let eventResponse):
                   DispatchQueue.main.async {
                       self?.isLoading = false
                       self?.events = eventResponse.message
                       print("Event Name i \(self?.events.first?.name ?? "no name")")
                   }
               case .failure(let error):
                   DispatchQueue.main.async {
                       self?.isLoading = false
                       self?.errorMessage = "Failed to get all the events: \(error.localizedDescription)"
                       print(error.localizedDescription)
                   }
               }
           }
       }
    
    
   
    
    
}
