import Foundation


@MainActor
final class GetOngoingEventsViewModel: ObservableObject {
  
  
  @Published var organizingEvents: [EventModel] = []
  @Published var joiningEvents: [EventModel] = []
  @Published var errorMessage: String = ""
  @Published var errorTitle: String = ""
  @Published var showErrorAlert: Bool = false
  @Published var isLoading: Bool = false
  @Published var organizingPrivateEvents: [EventModel] = []
  @Published var timeFilter: TimeFilter = .all

  private var loadingCount = 0 {
    didSet {
      DispatchQueue.main.async {
        self.isLoading = self.loadingCount > 0
      }
    }
  }
  
  
  
  
  init(){
    if let userId = KeychainManager.shared.keychain.get("appUserId") {
      fetchAllCurrentEvents(userId: userId)
    }
  }
  
  
  func fetchAllCurrentEvents(userId: String){
    let dispatchGroup = DispatchGroup()
    incrementLoading()
    
    dispatchGroup.enter()
    getJoiningEventsOfUser(userId: userId) {
      dispatchGroup.leave()
    }
    
    dispatchGroup.enter()
    getOrganizingEventsOfUser(userId: userId) {
      dispatchGroup.leave()
    }
    
    dispatchGroup.notify(queue: .main) {
      self.decrementLoading()
      print("All event history are fetched")
    }
  }
  
  
  func fetchOrganizingEventsConcurrently(userId:String){
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    getOrganizingEventsOfUser(userId: userId) {
      dispatchGroup.leave()
    }
    
    dispatchGroup.notify(queue: .main) {
      self.decrementLoading()
      print("organizing event history are fetched")
    }
    
    
  }
  
  var privateHostingEvents: [EventModel] {
    return organizingEvents.filter({$0.isPrivate ?? false})
  }
  
  
  func filerPrivateEvents(event: [EventModel]) -> [EventModel] {
    return event.filter({$0.isPrivate ?? false})
  }
  

  
  
  func getOrganizingEventsOfUser(userId: String,completion: @escaping () -> ()){
    incrementLoading()
    let organizingEventUseCase =  GetOrganizingEvents(userId: userId)
    organizingEventUseCase.execute(getMethod: "GET") { [weak self] result in
      self?.decrementLoading()
      switch result {
      case .success(let response):
        DispatchQueue.main.async {
          self?.organizingEvents = response.message
//          self?.organizingPrivateEvents = self?.filerPrivateEvents(event: self?.organizingEvents ?? []) ?? []
//          print("organizing private events count: \(self?.organizingPrivateEvents.count)")
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self?.setUpErrorAlert(error: error.localizedDescription)
        }
      }
      completion()
    }
  
  }
  
  
  func getJoiningEventsOfUser(userId: String,completion: @escaping () -> ()){
    incrementLoading()
    let organizingEventUseCase =  GetJoiningEvents(userId: userId)
    organizingEventUseCase.execute(getMethod: "GET") { [weak self] result in
      self?.decrementLoading()
      switch result {
      case .success(let response):
        DispatchQueue.main.async {
          self?.joiningEvents = response.message
          print("joining events is appened \(self?.joiningEvents.count)")
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self?.setUpErrorAlert(error: error.localizedDescription)
          print("error getting joining events due to \(error.localizedDescription)")
        }
      }
      completion()
    }
   
  }
  
  private func incrementLoading() {
        loadingCount += 1
    }
    
    private func decrementLoading() {
        loadingCount = max(loadingCount - 1, 0)
    }
  
  
  private func setUpErrorAlert(error: String){
    errorTitle = "Failed to get events"
    errorMessage = error
    showErrorAlert = true
  }
  
  
   var filteredJoiningEvents: [EventModel] {
      return joiningEvents.filter { event in
        matchesTimeFilter(event: event, timeFilter: timeFilter)
      }
  }
  
  
  
//   public func matchesTimeFilter(event: EventModel, timeFilter: TimeFilter) -> Bool {
//      guard let eventStartDate = parseDate(event.startDate) else { return false }
//      let currentDate = Date()
//     let calendar = Calendar(identifier: .gregorian)
//      
//      switch timeFilter {
//      case .all:
//        return true
//      case .today:
//        return calendar.isDate(eventStartDate, inSameDayAs: currentDate)
//      case .thisWeek:
//        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: currentDate) else { return false }
//             return weekStart.contains(eventStartDate)
//      case .thisMonth:
//        let eventYear = calendar.component(.year, from: eventStartDate)
//        let eventMonth = calendar.component(.month, from: eventStartDate)
//        let currentYear = calendar.component(.year, from: currentDate)
//        let currentMonth = calendar.component(.month, from: currentDate)
//        return eventYear == currentYear && eventMonth == currentMonth
//      }
//  }
     public func matchesTimeFilter(event: EventModel, timeFilter: TimeFilter) -> Bool {
      guard let eventStartDate = parseDate(event.startDate) else { return false }
      let currentDate = Date()
      
      switch timeFilter {
      case .all:
          return true
      case .today:
//          return Calendar.current.isDate(eventStartDate, inSameDayAs: currentDate)
          let gregorianCalendar = Calendar(identifier: .gregorian)
          return gregorianCalendar.isDate(eventStartDate, inSameDayAs: currentDate)
      case .thisWeek:
//          return Calendar.current.isDate(eventStartDate, equalTo: currentDate, toGranularity: .weekOfYear)
          let gregorianCalendar = Calendar(identifier: .gregorian)
          return gregorianCalendar.isDate(eventStartDate, equalTo: currentDate, toGranularity: .weekOfYear)
      case .thisMonth:
//          return Calendar.current.isDate(eventStartDate, equalTo: currentDate, toGranularity: .month)
          let gregorianCalendar = Calendar(identifier: .gregorian)
          return gregorianCalendar.isDate(eventStartDate, equalTo: currentDate, toGranularity: .month)

      }
         
  }
  
  // Parse the event date string and convert it to Thailand's local time zone
//  private func parseDate(_ dateString: String) -> Date? {
//      let formatter = DateFormatter()
//      formatter.dateFormat = "yyyy-MM-dd" // Adjust based on your event date format
//      formatter.timeZone = TimeZone(identifier: "Asia/Bangkok") // Thailand time zone
//      
//      if let date = formatter.date(from: dateString) {
//          // No need for conversion as it's already in Thailand's time zone
//          return date
//      }
//      return nil
//  }
  
  private func parseDate(_ dateString: String) -> Date? {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd" // Server date format
      formatter.timeZone = TimeZone(identifier: "Asia/Bangkok") // Thailand time zone

      if let date = formatter.date(from: dateString) {
          // Set time to noon to avoid time zone edge cases
          var components = Calendar.current.dateComponents(in: formatter.timeZone!, from: date)
          components.hour = 12
          return Calendar.current.date(from: components)
      }
      return nil
  }

  
}


