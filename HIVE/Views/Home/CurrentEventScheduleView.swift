import SwiftUI

struct CurrentEventScheduleView: View {
  
  @StateObject var viewModel: GetOngoingEventsViewModel
  @State private var showHosting: Bool = false
  
  
  init(){
    _viewModel = StateObject(wrappedValue: GetOngoingEventsViewModel())
  }
  
  var body: some View {
    ZStack {
      if viewModel.isLoading {
        ProgressView("Loading")
      } else {
        VStack(alignment:.leading,spacing:24) {
          header
          eventScrollView
          
        }
        .padding(.horizontal)
        
      }
  }
    
    .refreshable {
      print("REFERSHING")
      if let userId = KeychainManager.shared.keychain.get("appUserId") {
        viewModel.fetchAllEventHistory(userId: userId)
        print("rfreshed with \(viewModel.joiningEvents.count)")
      }
    }
    .padding(.horizontal)
      .alert(isPresented: $viewModel.showErrorAlert){
        Alert(title: Text(viewModel.errorTitle),
          message: Text(viewModel.errorMessage),
          dismissButton: .default(Text("OK")))
      }
      .navigationTitle("Schedule")
      .navigationBarTitleDisplayMode(.inline)
    }
  
}

#Preview {
  NavigationStack {
    CurrentEventScheduleView()
  }
}

extension CurrentEventScheduleView {
  private var header: some View {
    HStack {
      VStack(alignment:.center,spacing: 4){
        Text("Upcoming")
          .heading5()
          .onTapGesture {
            withAnimation(.interactiveSpring) {
              showHosting.toggle()
            }
          }
        Rectangle()
          .frame(width:200,height:2)
          .foregroundStyle(Color.black)
          .opacity(showHosting ? 0 : 1)
      }
     
      VStack(alignment:.center,spacing:4){
        Text("Hosting")
          .heading5()
          .onTapGesture {
            withAnimation(.interactiveSpring) {
              showHosting.toggle()
            }
          }
        Rectangle()
          .frame(width:200,height:2)
          .foregroundStyle(Color.black)
          .opacity(showHosting ? 1 : 0)
      }
    }
    .frame(maxWidth: .infinity)
  }
  
  private var eventScrollView: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment:.leading,spacing:24) {
        
        if viewModel.organizingEvents.count != 0 || viewModel.joiningEvents.count != 0 {
          RelatedTimeFrameEvents(viewModel: viewModel, timeFilter: .today, showHosting: $showHosting)
          divider
          RelatedTimeFrameEvents(viewModel: viewModel, timeFilter: .thisWeek, showHosting: $showHosting)
          divider
          RelatedTimeFrameEvents(viewModel: viewModel, timeFilter: .thisMonth, showHosting: $showHosting)
          divider
          RelatedTimeFrameEvents(viewModel: viewModel, timeFilter: .all, showHosting: $showHosting)
        } else {
          ZStack {
            Color.white
            VStack(alignment:.center,spacing: 12){
              Image(systemName: "clock.badge.xmark")
                .resizable()
                .scaledToFit()
                .frame(width:60,height: 60)
              Text(showHosting ? "No currently hosting events" : "No current joining events")
                .font(.subheadline)
                .fontWeight(.medium)
            }
          }
          .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
        }
      }
    }
    .padding(.horizontal,12)
  }
  
  private var divider: some View {
    Rectangle()
      .frame(maxWidth: .infinity)
      .frame(height:1)
      .foregroundStyle(.divider)
      .padding(.horizontal,12)
  }
}

struct RelatedTimeFrameEvents: View {
  @ObservedObject var viewModel: GetOngoingEventsViewModel
  var timeFilter: TimeFilter
  @Binding var showHosting: Bool
  @EnvironmentObject var appCoordinator: AppCoordinatorImpl
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text(timeFilter.rawValue)
        .heading5half()
      let filteredHostingEvents = viewModel.organizingEvents.filter { viewModel.matchesTimeFilter(event: $0, timeFilter: timeFilter) }
      let filteredJoiningEvents = viewModel.joiningEvents.filter { viewModel.matchesTimeFilter(event: $0, timeFilter: timeFilter) }
//      if filteredHostingEvents.count != 0 || filteredJoiningEvents.count != 0 {
        ForEach(showHosting ? filteredHostingEvents : filteredJoiningEvents, id: \._id) { event in
          CurrentEventRow(event: event)
            .padding(.horizontal,12)
            .onTapGesture {
              appCoordinator.push(.eventDetailView(named: event))
            }
        }
    
        
        
//      }
    }
  }
}
