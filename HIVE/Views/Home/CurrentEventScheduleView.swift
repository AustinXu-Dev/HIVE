import SwiftUI

struct CurrentEventScheduleView: View {
  
  @StateObject var viewModel = GetOngoingEventsViewModel()
  @State private var showHosting: Bool = false
  
  var body: some View {
    ZStack {
      if viewModel.isLoading {
        ProgressView()
      } else {
        VStack(alignment:.leading,spacing:24) {
          header
          eventScrollView
        }
        .padding(.horizontal)
        
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
          .bold()
          .font(.headline)
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
          .bold()
          .font(.headline)
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
  }
  
  private var eventScrollView: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment:.leading,spacing:24) {
        
        if viewModel.organizingEvents.count != 0 && viewModel.joiningEvents.count != 0 {
          RelatedTimeFrameEvents(viewModel: viewModel, timeFilter: .today, showHosting: $showHosting)
          Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height:1)
            .foregroundStyle(.divider)
            .padding(.horizontal,12)
          RelatedTimeFrameEvents(viewModel: viewModel, timeFilter: .thisWeek, showHosting: $showHosting)
          Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height:1)
            .foregroundStyle(.divider)
            .padding(.horizontal,12)
          RelatedTimeFrameEvents(viewModel: viewModel, timeFilter: .thisMonth, showHosting: $showHosting)
          Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height:1)
            .foregroundStyle(.divider)
            .padding(.horizontal,12)
          RelatedTimeFrameEvents(viewModel: viewModel, timeFilter: .all, showHosting: $showHosting)
        } else {
          VStack(alignment:.center,spacing: 12){
            Image(systemName: "clock.badge.xmark")
              .scaledToFit()
              .frame(width:60,height: 60)
            Text(showHosting ? "No currently hosting events" : "No current joining events")
              .font(.subheadline)
              .fontWeight(.medium)
          }
        }
      }
    }
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
          .bold()
          let filteredHostingEvents = viewModel.organizingEvents.filter { viewModel.matchesTimeFilter(event: $0, timeFilter: timeFilter) }
          let filteredJoiningEvents = viewModel.joiningEvents.filter { viewModel.matchesTimeFilter(event: $0, timeFilter: timeFilter) }

      ForEach(showHosting ? filteredHostingEvents : filteredJoiningEvents, id: \._id) { event in
              CurrentEventRow(event: event)
                  .padding(.horizontal,12)
                  .onTapGesture {
                      appCoordinator.push(.eventDetailView(named: event))
                  }
          }
      }
  }
}
