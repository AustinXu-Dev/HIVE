//
//  EventCreationView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import SwiftUI
import PhotosUI

struct EventCreationView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showPhotoPicker: Bool = false
    
    @State private var eventTitle: String = ""
    @State private var eventLocation: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = (Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
    @State private var additionalInfo: String = ""
    @State private var selectedCategories: [String] = []
    @State private var isCategoryExpanded: Bool = false
    @State private var invalidFields: Set<String> = []
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject var eventCreationVM = UserCreateEventViewModel()
    @StateObject var profileVM = GetOneUserByIdViewModel()
    @State private var eventPhoto: UIImage?
    @Environment(\.isGuest) private var isGuest: Bool
    @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue
    @State private var showCreateAccountAlert: Bool = false
    
    @State private var isPrivate: Bool = false
    @State private var allowMaxParticipants: Bool = false
    @State private var participantCount: Int = 20
    @State private var minimumAge: Int = 18
    @State private var allowMinimumAge: Bool = false
    @State private var showRestriction: Bool = false
    @FocusState private var isFocused: Bool
    @State private var showPrivateEventTipAlert: Bool = false
    
    let categories = ["Drinks", "Casual", "Music", "Party", "Private", "Gathering", "Active", "Chill", "Outdoor", "Bar", "Dance", "Quiet", "Games", "Exclusive", "Networking"]
    
    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
   
    let screenSize = UIScreen.main.bounds.size
   

    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .all)
            if eventCreationVM.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        eventImage
                            .frame(maxHeight: 230)
                        eventName
                        eventVenue
                        
                        Divider()
                        
                        eventDateTime
                        eventRestriction
                        
                        Divider()
                        
                        eventCategory
                        
                        eventAdditionalInfo
                        
                        publishButton
                            .padding(.bottom,8)
                    }
                    .padding(.top, 16)
                    .onTapGesture {
                        isFocused = false
                    }
                    .padding(.horizontal, 16)
                }
                .safeAreaInset(edge: .top, content: {
                    Color.clear
                        .frame(height: 50)
                })
                .overlay {
                    headerRow
                }
                .onAppear {
                    if let userId = KeychainManager.shared.keychain.get("appUserId") {
                        profileVM.getOneUserById(id: userId)
                    }
                    
                    if userAppState == AppState.guest.rawValue {
                        self.showCreateAccountAlert = true
                    }
                }
                .onReceive(eventCreationVM.$eventCreationSuccess) { success in
                    if success {
                        appCoordinator.push(.eventCreationSuccess)
                    }
                }
                .alert(isPresented: $showCreateAccountAlert) {
                    Alert(
                        title: Text("Create or Log In to An Account"),
                        message: Text("To host events, you must create a new account first or log in to the existing account."),
                        primaryButton: .default(Text("Sign Up/Sign In"), action: {
                            appCoordinator.popToRoot()
                            userAppState = AppState.notSignedIn.rawValue
                        }),
                        secondaryButton: .destructive(Text("Cancel"))
                    )
                }
                .alert(isPresented: $showPrivateEventTipAlert) {
                    Alert(
                        title: Text("Private Event"),
                        message: Text("You will approve who can attend. Location stays hidden until you approve."),
                        dismissButton: .cancel(Text("Got it"))
                    )
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden)
        .onTapGesture {
            self.hideKeyboard()
            print("Keyboard hidden")
        }
        
    }

    private var headerRow: some View {
        ZStack{
            Color.clear
               // .frame(height: 120)
                .frame(height: screenSize.height <= 667 ? 90 : 120 )// iPhone SE (1st and 2nd gen) or smaller)

                .background(.white)
                .blur(radius: 1)
                .ignoresSafeArea(edges: .top)
            HStack {
                Spacer()
                Text("Create Event")
                    .heading5()
                Spacer()
            }
//            .offset(y: -30)
            .offset(y: isIPad ? -40 : -30)
            .padding(.horizontal)
        }.frame(maxHeight: .infinity, alignment: .top)
    }
    
    func toggleCategory(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
        } else {
            selectedCategories.append(category)
        }
    }
    
    private func validateForm() {
        
        invalidFields.removeAll()
        
        
        if selectedImage == nil {
            invalidFields.insert("photo")
        }
        
        if eventTitle.isEmpty {
            invalidFields.insert("title")
        }
        
        if eventTitle.count > 40 {
            invalidFields.insert("invalidTitle")
        }
        
        if eventLocation.isEmpty {
            invalidFields.insert("location")
        }
        
        if eventLocation.count > 50 {
            invalidFields.insert("invalidLocation")
        }
        
        if additionalInfo.isEmpty {
            invalidFields.insert("additionalInfo")
        }
        
        if additionalInfo.count > 200 {
            invalidFields.insert("invalidAdditionalInfo")
            
        }
        
        validateCategory()
        validateDate()
        
        invalidFields.forEach { print("invalid fields" ,$0) }
        
    }
    
    private func validateDate(){
        invalidFields.remove("invalidDateRange")
        let start = startDate
        let end = endDate
        print("Start: \(start)")
        print("End \(end)")
        
        if end <= start {
            invalidFields.insert("invalidDateRange")
        }
    }
    
    private func validateCategory(){
        invalidFields.remove("categories")
        
        if selectedCategories.count < 1 || selectedCategories.count > 3 {
            invalidFields.insert("categories")
        }
        
    }
    
    func createEvent(){
        eventCreationVM.isLoading = true
        print("Create event func enterred")
        let eventStartDate = startDate.formatDateToString()
        let eventEndDate = endDate.formatDateToString()
        let eventStartTime = startDate.formatTimeToString()
        let eventEndTime = endDate.formatTimeToString()
        
        
        
        
        eventCreationVM.name = eventTitle
        eventCreationVM.location = eventLocation
        eventCreationVM.startDate = eventStartDate
        eventCreationVM.endDate = eventEndDate
        eventCreationVM.startTime = eventStartTime
        eventCreationVM.endTime = eventEndTime
        eventCreationVM.maxParticipants = 100
        eventCreationVM.category = selectedCategories
        eventCreationVM.additionalInfo = additionalInfo
        if allowMaxParticipants{
            eventCreationVM.maxParticipants = participantCount
        }
        if allowMinimumAge{
            eventCreationVM.minAge = minimumAge
        }
        eventCreationVM.isPrivate = isPrivate
        
        
        
        
        print("event creation request initiated")
        
        guard let uid = profileVM.userDetail?._id, let email = profileVM.userDetail?.email else {
            return
        }
        
        print("UID \(uid) & email \(email)")
        
        eventCreationVM.uploadImage(selectedImage ?? UIImage(named:"event")!) { result in
            print("Uploading image...")
            //            guard let strongSelf = self else { return }
            switch result {
            case .success(let imageURL):
                print(imageURL)
                self.storeImageUrlAndRetrieveImage(uid: uid, email: email, imageUrl: imageURL)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //        }
        
        
        
        
        
        
        
    }
    
    private func storeImageUrlAndRetrieveImage(uid: String, email: String, imageUrl: String) {
        print("storing...")
        eventCreationVM.storeImageUrl(imageUrl: imageUrl, uid: uid, email: email) { result in
            switch result {
            case .success(_):
                self.retrieveImageURL(uid: uid)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    private func retrieveImageURL(uid: String){
        print("reteriving...")
        eventCreationVM.retrieveImageUrl(uid: uid) { result in
            switch result {
            case .success(let storedImageUrl):
                print("stored image url \(storedImageUrl)")
                eventCreationVM.eventImageUrl = storedImageUrl
                
                if !eventCreationVM.eventImageUrl.isEmpty, let userToken = TokenManager.share.getToken()  {
                    
                    eventCreationVM.createEvent(token:userToken)
                    print("event creation request sent")
                    resetFields()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

struct EventCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EventCreationView()
        }
    }
}


extension EventCreationView {
    
    private var customToolbar : some View {
        HStack {
            Spacer()
            Button(action: {
                if userAppState != AppState.guest.rawValue {
                    validateForm()
                    if invalidFields.isEmpty {
                        print("Form is valid")
                        createEvent()
                    } else {
                        print("Form is not valid")
                    }
                    
                } else {
                    showCreateAccountAlert = true
                }
            }) {
                Text("Finish")
                    .foregroundStyle(Color.black)
            }
        }
    }
    
    private var eventImage: some View {
        VStack {
            if let eventPhoto = selectedImage {
                Image(uiImage: eventPhoto)
                    .resizable()
                    .frame(maxWidth: 360)
                    .frame(maxHeight: 230)
                    .aspectRatio(contentMode: .fill)
                    .clipShape((RoundedRectangle(cornerRadius: 10)))
            } else {
                eventImagePlaceholder
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 230)
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPicker(selectedImage: $selectedImage, cropSize: CGSize(width: 360, height: 230))
        }
        .onTapGesture {
            showPhotoPicker = true
        }
    }
    
    
    private var eventImagePlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red, lineWidth: invalidFields.contains("photo") ? 1.0 : 0.0)
                .fill(Color.gray.opacity(0.3))
                .animation(.linear(duration: 0.001), value: invalidFields.contains("title"))
            
            Circle()
                .frame(height: 40)
                .foregroundStyle(Color.black.opacity(0.5))
            
            Image(systemName: "photo")
                .frame(width: 25, height: 25)
                .font(.system(size: 20))
                .foregroundStyle(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(height: 230)
        
    }
    
    private var eventName : some View {
        VStack(alignment: .center, spacing: 5) {
            Text("Choose a Catchy Title!")
                .font(CustomFont.createEventTitle)
            ZStack {
                
                // validating if (1) title contains value and (2) character limit
                if eventTitle.isEmpty {
                    Text("Event Title")
                        .font(CustomFont.createEventBody)
                        .foregroundStyle(invalidFields.contains("title") || invalidFields.contains("invalidTitle") ? Color.red : Color.gray)
                        .animation(.linear(duration: 0.001), value: invalidFields.contains("title") || invalidFields.contains("invalidTitle"))
                        .padding(.horizontal)
                }
                TextField("", text: $eventTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(CustomFont.createEventBody)
                    .background(Color.clear)
                    .frame(maxWidth:300)
                    .frame(maxHeight:20)
                    .cornerRadius(8)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .onChange(of: eventTitle) { _,newEventName in
                        if !newEventName.isEmpty {
                            invalidFields.remove("title")
                        }
                        
                        if newEventName.count > 40 {
                            invalidFields.insert("invalidTitle")
                        } else {
                            invalidFields.remove("invalidTitle")
                        }
                        
                    }
            }
            .frame(maxWidth: .infinity)
            Rectangle()
                .frame(width:200,height:2)
                .foregroundStyle(invalidFields.contains("title") || invalidFields.contains("invalidTitle") ? Color.red.opacity(0.5) : Color.black)
                .animation(.linear(duration: 0.001), value: invalidFields.contains("title") || invalidFields.contains("invalidTitle") )
            
            if invalidFields.contains("invalidTitle") {
                Text("Char Limit - Only Up to 40")
                    .font(.system(size:12))
                    .foregroundStyle(Color.red)
                    .animation(.linear(duration: 0.001), value: invalidFields.contains("invalidTitle"))
            }
            
            
        }
        .frame(maxWidth: .infinity)
    }
    
    private var eventVenue : some View {
        VStack(alignment: .center, spacing: 5) {
            Text("Where will it be?")
                .font(CustomFont.createEventTitle)
            ZStack{
                // Placeholder text
                if eventLocation.isEmpty {
                    Text("Event Location")
                        .font(CustomFont.createEventBody)
                        .foregroundStyle(invalidFields.contains("location") || invalidFields.contains("invalidLocation") ? Color.red : Color.gray)
                        .animation(.linear(duration: 0.001), value: invalidFields.contains("location") || invalidFields.contains("invalidLocation"))
                        .padding(.horizontal)
                    
                }
                TextField("", text: $eventLocation)
                    .multilineTextAlignment(.center)
                    .font(CustomFont.createEventBody)
                    .padding()
                    .frame(maxWidth:200)
                    .frame(maxHeight:20)
                    .cornerRadius(8)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .onChange(of: eventLocation) { _,newEventLocation in
                        if !newEventLocation.isEmpty {
                            invalidFields.remove("location")
                        }
                        
                        if newEventLocation.count > 50 {
                            invalidFields.insert("invalidLocation")
                        } else {
                            invalidFields.remove("invalidLocation")
                        }
                    }
                
            }
            .frame(maxWidth: .infinity)
            Rectangle()
                .frame(width:200,height:2)
                .foregroundStyle(invalidFields.contains("location") || invalidFields.contains("invalidLocation") ? Color.red.opacity(0.5) : Color.black)
                .animation(.linear(duration: 0.001), value: invalidFields.contains("location") || invalidFields.contains("invalidLocation"))
            
            if invalidFields.contains("invalidLocation") {
                Text("Char Limit - Only Up to 50")
                    .font(.system(size:12))
                    .foregroundStyle(Color.red)
                    .animation(.linear(duration: 0.001), value: invalidFields.contains("invalidLocation"))
            }
            
        }
        .frame(maxWidth: .infinity)
        
    }
    
    private var eventDateTime : some View {
        VStack(alignment:.leading,spacing: 10) {
            if invalidFields.contains("invalidDateRange") {
                Text("End Date&Time should be \nbeyond Start Date&Time.")
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(invalidFields.contains("invalidDateRange") ? Color.red : Color.black)
                    .animation(.linear(duration: 0.001), value: invalidFields.contains("invalidDateRange"))
            }
            HStack {
                Text("Start:")
                    .font(CustomFont.createEventSubBody)
                    .foregroundStyle(invalidFields.contains("invalidDateRange") ? Color.red : Color.black)
                    .animation(.linear(duration: 0.001), value: invalidFields.contains("invalidDateRange"))
                Spacer()
                DatePicker("",
                           selection: $startDate,
                           in: Date()...,
                           displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .datePickerStyle(.compact)
                .environment(\.calendar, Calendar(identifier: .gregorian))
                .environment(\.locale, Locale(identifier: "en_US"))
                .onChange(of: startDate) { _,_ in
                    validateDate()
                }
            }
            .environment(\.calendar, Calendar(identifier: .gregorian))
            .environment(\.locale, Locale(identifier: "en_US"))
            
            HStack {
                Text("End:")
                    .font(CustomFont.createEventSubBody)
                    .foregroundStyle(invalidFields.contains("invalidDateRange") ? Color.red : Color.black)
                    .animation(.linear(duration: 0.001), value: invalidFields.contains("invalidDateRange"))
                Spacer()
                DatePicker("",
                           selection: $endDate,
                           in: Date()...,
                           displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .datePickerStyle(.compact)
                .environment(\.calendar, Calendar(identifier: .gregorian))
                .environment(\.locale, Locale(identifier: "en_US"))
                
                .onChange(of: endDate) { _,_ in
                    validateDate()
                }
            }
            .environment(\.calendar, Calendar(identifier: .gregorian))
            .environment(\.locale, Locale(identifier: "en_US"))
            
        }
    }
    
    private var eventRestriction: some View{
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Toggle(isOn: $isPrivate) {
                    HStack{
                        Text("Private")
                            .font(CustomFont.createEventSubBody)
                        Image(systemName: "info.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:15,height:15)
                            .onTapGesture {
                                showPrivateEventTipAlert.toggle()
                            }
                            .alert(isPresented: $showPrivateEventTipAlert){
                                Alert(title:  Text("Private Event")
                                      ,message:  Text("You will approve of who can attend. Location stays hidden until you approved."),
                                      dismissButton: .cancel(Text("Got it"))
                                      
                                      
                                )
                            }
                        
                        
                    }
                }
            }
            HStack{
                Text("Restriction")
                    .font(CustomFont.createEventSubBody)
                Image(systemName: showRestriction ? "chevron.down" : "chevron.up")
                    .onTapGesture {
                        showRestriction.toggle()
                    }
            }
            
            if showRestriction{
                Toggle(isOn: $allowMaxParticipants) {
                    HStack{
                        Text("Max Participants:")
                            .font(CustomFont.createEventSubBody)
                        Spacer()
                        if allowMaxParticipants{
                            Text("\(participantCount)")
                            Stepper("", value: $participantCount)
                                .labelsHidden()
                        }
                    }
                }
                
                Toggle(isOn: $allowMinimumAge) {
                    HStack{
                        Text("Minimum Age:")
                            .font(CustomFont.createEventSubBody)
                        Spacer()
                        if allowMinimumAge{
                            Text("\(minimumAge)")
                            Stepper("", value: $minimumAge)
                                .labelsHidden()
                        }
                    }
                }
            }
        }
    }
    
    private var eventCategory: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title and Description
            Text("Category")
                .font(CustomFont.createEventTitle)
            
            Text("Select between 1 and 3 categories")
                .font(CustomFont.createEventBody)
                .foregroundStyle(invalidFields.contains("categories") ? Color.red : Color.gray)
                .animation(.linear, value: invalidFields.contains("categories"))
            
            // Dynamic Category Buttons
            VStack(alignment: .leading, spacing: 10) {
                let rows = getRows(items: categories, maxWidth: UIScreen.main.bounds.width - 40)
                
                ForEach(isCategoryExpanded ? rows.indices : rows.indices.prefix(1), id: \.self) { index in
                    let row = rows[index]
                    HStack {
                        ForEach(row, id: \.self) { category in
                            Button(action: {
                                toggleCategory(category)
                            }) {
                                Text(category)
                                    .font(CustomFont.createEventBody)
                                    .lineLimit(1)
                                    .foregroundStyle(Color.black)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 6)
                                    .background(selectedCategories.contains(category) ? Color.blue.opacity(0.65) : Color.gray.opacity(0.2))
                                    .cornerRadius(30)
                            }
                        }
                        Spacer()
                    }
                }
                
            }
            
            // Expand/Collapse Button
            Button(action: {
                withAnimation(.linear(duration: 0.35)) {
                    isCategoryExpanded.toggle()
                }
            }) {
                Circle()
                    .frame(height: 27)
                    .foregroundStyle(Color.black)
                    .overlay(
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isCategoryExpanded ? 180 : 0))
                            .foregroundStyle(.white)
                    )
            }
            Spacer()
        }
        .onChange(of: selectedCategories) { _, _ in
            validateCategory()
        }
    }
    
    // Helper function to calculate rows for categories
    private func getRows(items: [String], maxWidth: CGFloat) -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var currentWidth: CGFloat = 0
        
        let padding: CGFloat = 45 // Total padding for a button (left + right)
        
        for item in items {
            let buttonWidth = (item.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]).width + padding)
            
            if currentWidth + buttonWidth > maxWidth {
                rows.append(currentRow)
                currentRow = [item]
                currentWidth = buttonWidth
            } else {
                currentRow.append(item)
                currentWidth += buttonWidth
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        return rows
    }
    
    
    
    
    private var eventAdditionalInfo : some View {
        VStack(alignment: .leading) {
            Text("Additional info")
                .font(CustomFont.createEventTitle)
            
            if invalidFields.contains("invalidAdditionalInfo") {
                Text("Char Limit - Only Up to 200")
                    .font(.system(size:12))
                    .foregroundStyle(Color.red)
                    .animation(.linear(duration: 0.001), value: invalidFields.contains("invalidAdditionalInfo"))
            }
            
            ZStack(alignment: .topLeading) {
                // Placeholder text
                if additionalInfo.isEmpty {
                    Text("Share the details here...")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                
                
                
                
                TextEditor(text: $additionalInfo)
                    .font(CustomFont.createEventBody)
                    .frame(height: 150)
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(8)
                    .focused($isFocused)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(invalidFields.contains("additionalInfo") || invalidFields.contains("invalidAdditionalInfo")  ? Color.red : Color.gray, lineWidth: 1)
                            .animation(.linear(duration: 0.001), value: invalidFields.contains("additionalInfo") || invalidFields.contains("invalidAdditionalInfo"))
                    )
                
                
                    .onChange(of: additionalInfo) { _,newAdditionalInfo in
                        if !newAdditionalInfo.isEmpty {
                            invalidFields.remove("additionalInfo")
                        }
                        
                        if newAdditionalInfo.count > 200 {
                            invalidFields.insert("invalidAdditionalInfo")
                        } else {
                            invalidFields.remove("invalidAdditionalInfo")
                            
                        }
                    }
                
            }
        }
    }
    
    
    private var publishButton: some View{
        VStack {
            Spacer()
            Button(action: {
                // Button action from previos finish button
                if userAppState != AppState.guest.rawValue {
                    validateForm()
                    if invalidFields.isEmpty {
                        print("Form is valid")
                        createEvent()
                    } else {
                        print("Form is not valid")
                    }
                    
                } else {
                    showCreateAccountAlert = true
                }
            }) {
                ZStack{
                    RoundedRectangle(cornerRadius: 35)
                        .shadow(color: Color("shadowColor"), radius: 5, x: 0, y: 0)
                        .frame(width: 250, height: 60)
                        .overlay {
                            Text("Publish")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 250, height: 60)
                                .background(Color.white)
                                .cornerRadius(35)
                        }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .shadow(color: Color("shadowColor"), radius: 10, x: 0, y: 0)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var isFormValid: Bool {
        !eventTitle.isEmpty && !eventLocation.isEmpty && !additionalInfo.isEmpty && selectedCategories.count >= 3 && (endDate > startDate)
    }
    
    private func resetFields() {
        selectedItem = nil
        selectedImage = nil
        eventTitle = ""
        eventLocation = ""
        startDate = Date()
        endDate = Date()
        additionalInfo = ""
        selectedCategories = []
        invalidFields.removeAll()
    }
}
