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

  
  
  init(){
    if let userId = KeychainManager.shared.keychain.get("appUserId"), let token = TokenManager.share.getToken() {
      getOrganizingEventsOfUser(userId: userId, token: token)
      getJoiningEventsOfUser(userId: userId, token: token)

      print("Fetch successfull")
      print(joiningEvents)
    }
  }
  
  func filerPrivateEvents(event: [EventModel]) -> [EventModel] {
    return event.filter({$0.isPrivate ?? false})
  }
  

  
  
  func getOrganizingEventsOfUser(userId: String,token: String){
    DispatchQueue.main.async {
      self.isLoading = true
    }
    let organizingEventUseCase =  GetOrganizingEvents(userId: userId)
    organizingEventUseCase.execute(getMethod: "GET", token: token) { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
      switch result {
      case .success(let response):
        DispatchQueue.main.async {
          self?.organizingEvents = response.message
          self?.organizingPrivateEvents = self?.filerPrivateEvents(event: self?.organizingEvents ?? []) ?? []
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
        }
      }
    }
  }
  
  
  func getJoiningEventsOfUser(userId: String,token: String){
    DispatchQueue.main.async {
      self.isLoading = true
    }
    let organizingEventUseCase =  GetJoiningEvents(userId: userId)
    organizingEventUseCase.execute(getMethod: "GET", token: token) { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
      switch result {
      case .success(let response):
        DispatchQueue.main.async {
          self?.joiningEvents = response.message
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
          self?.setUpErrorAlert(error: error.localizedDescription)
        }
      }
    }
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
  
  
  
   public func matchesTimeFilter(event: EventModel, timeFilter: TimeFilter) -> Bool {
      guard let eventStartDate = parseDate(event.startDate) else { return false }
      let currentDate = Date()
     let calendar = Calendar(identifier: .gregorian)
      
      switch timeFilter {
      case .all:
             return true
         case .today:
             return calendar.isDate(eventStartDate, inSameDayAs: currentDate)
         case .thisWeek:
             guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: currentDate) else { return false }
             return weekStart.contains(eventStartDate)
         case .thisMonth:
             let eventYear = calendar.component(.year, from: eventStartDate)
             let eventMonth = calendar.component(.month, from: eventStartDate)
             let currentYear = calendar.component(.year, from: currentDate)
             let currentMonth = calendar.component(.month, from: currentDate)
             return eventYear == currentYear && eventMonth == currentMonth
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


