//
//  GetEventsViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import Foundation


class GetEventsViewModel : ObservableObject {
    
    //MARK: - replace the mock data with data returned from server later on
    @Published var events : [EventModel] = EventMock.instance.events
    
    
    
}
