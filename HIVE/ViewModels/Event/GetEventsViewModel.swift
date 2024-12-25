//
//  GetEventsViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import Foundation


class GetEventsViewModel : ObservableObject {
    
    @Published var events : [EventModel] = []
    @Published var currentEvent: EventModel? = nil
//    {
//        didSet{
//            getOneEvent(id: currentEvent?._id ?? "")
//        }
//    }
    @Published var isLoading : Bool = false
    @Published var errorMessage : String? = nil
    @Published var showErrorAlert: Bool = false
    
    
    
    init(){
        fetchEvents()
    }
    
    
    private let getAllEvents = GetAllEvents()
    
    func fetchEvents() {
        guard !isLoading else { return }
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
                    print("Error getting all event")
                    self?.isLoading = false
                    self?.setUpErrorAlert(errorMessage: error.localizedDescription)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getOneEvent(id: String) {
        let getOneEvent = GetOneEventById(id: id)
        
        getOneEvent.execute(getMethod: "GET") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let event):
                    self.currentEvent = event.message
                    if let index = self.events.firstIndex(where: { $0._id == id }) {
                        self.events[index] = event.message
                    }
                case .failure(let failure):
                    print("Get one event error: \(failure.localizedDescription)")
                }
            }
        }
        
    }
    
    
    private func setUpErrorAlert(errorMessage: String){
        self.errorMessage = errorMessage
        showErrorAlert = true
    }
    
    
}
