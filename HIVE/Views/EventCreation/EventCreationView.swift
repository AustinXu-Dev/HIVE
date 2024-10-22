//
//  EventCreationView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import SwiftUI
import PhotosUI


struct EventCreationView: View {
    @State private var selectedItem: PhotosPickerItem? // Holds the selected item
    @State private var selectedImage: UIImage? // Holds the selected image

    @State private var eventTitle: String = ""
    @State private var eventLocation: String = ""
    @State private var startDate : Date = Date()
    @State private var endDate : Date = Date()
    @State private var additionalInfo: String = ""
    @State private var selectedCategories: [String] = []
    @State private var isCategoryExpanded: Bool = false
    @State private var invalidFields: Set<String> = []
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject var eventCreationVM = UserCreateEventViewModel()
    @StateObject var profileVM = GetOneUserByIdViewModel()
    @State private var eventPhoto: UIImage?


    
    let categories = ["Bar", "Outdoor", "Music", "Sport", "Food", "Art", "Business", "Tech"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    eventImage
                    eventName
                    
                    eventVenue
                    
                    
                    Divider()
                    
                    eventDateTime
                    
                    Divider()
                    
                    eventCategory
                    
                    eventAdditionalInfo
                    
                    
                }
                .padding()
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Left button tapped")
                    }) {
                        HStack(spacing:2) {
                            Image(systemName: "chevron.left")
                            
                            Text("Save")
                            
                        }
                        .foregroundStyle(Color.black)
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        validateForm()
                      if invalidFields.isEmpty {
                         print("Form is valid")
                          createEvent()
                      } else {
                          print("Form is not valid")
                      }
                    
                    }) {
                        Text("Finish")
                            .foregroundStyle(Color.black)
                    }
                }
            }
            
        }
        .onAppear {
            if let userId = KeychainManager.shared.keychain.get(""){
                profileVM.getOneUserById(id: userId)
            }
        }
    }
    // Function to toggle category selection
    func toggleCategory(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
        } else {
            selectedCategories.append(category)
        }
    }
    
    // Function to validate the form
     private func validateForm() {
             
         invalidFields.removeAll()
         if eventTitle.isEmpty {
             invalidFields.insert("title")
         }
         if eventLocation.isEmpty {
             invalidFields.insert("location")
         }
         if additionalInfo.isEmpty {
             invalidFields.insert("additionalInfo")
         }
         if selectedCategories.count < 3 {
             invalidFields.insert("categories")
         }
         
         let start = startDate
         let end = endDate

         if end <= start {
             invalidFields.insert("invalidDateRange")
         }
     }
    
    func createEvent(){
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
        eventCreationVM.isLimited = false
        eventCreationVM.category = selectedCategories
        eventCreationVM.additionalInfo = additionalInfo
    
        



        print("event creation request initiated")
        
        guard let uid = profileVM.userDetail?._id, let email = profileVM.userDetail?.email else { return }
        
        eventCreationVM.uploadImage(selectedImage ?? UIImage(named:"event")!) { result in
//            guard let strongSelf = self else { return }
            switch result {
            case .success(let imageURL):
                print(imageURL)
                self.storeImageUrlAndRetrieveImage(uid: uid, email: email, imageUrl: imageURL)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        if !eventCreationVM.eventImageUrl.isEmpty, let userToken = TokenManager.share.getToken()  {
            eventCreationVM.createEvent(token:userToken)
            print("event creation request sent")
        }
//        }
      
        
        
      
        


    }
    
    private func storeImageUrlAndRetrieveImage(uid: String, email: String, imageUrl: String) {
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
        eventCreationVM.retrieveImageUrl(uid: uid) { result in
            switch result {
            case .success(let storedImageUrl):
                print("stored image url \(storedImageUrl)")
                eventCreationVM.eventImageUrl = storedImageUrl
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
     
}

struct EventCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EventCreationView(eventCreationVM: UserCreateEventViewModel())
        }
    }
}


extension EventCreationView {
    private var eventImage: some View {
            VStack {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        // Display selected image or placeholder
                        if let eventPhoto = selectedImage {
                            Image(uiImage: eventPhoto)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                                .cornerRadius(10)
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 200)
                                Circle()
                                    .frame(height: 40)
                                    .foregroundStyle(Color.black.opacity(0.5))
                                Image(systemName: "photo")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .onChange(of: selectedItem) { _,newItem in
                        Task {
                            // Retrieve selected asset
                            if let newItem = newItem {
                                // Retrieve the selected asset in the background
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    if let image = UIImage(data: data) {
                                        selectedImage = image // Assign the image
                                    }
                                }
                            }
                        }
                    }
            }
        }
    
    private var eventName : some View {
        VStack(alignment: .center, spacing: 5) {
            Text("Choose a Catchy Title!")
                .font(.headline)
            ZStack(alignment: .leading) {
                // Placeholder text
                if eventTitle.isEmpty {
                    Text("Event Title")
                        .foregroundStyle(invalidFields.contains("title") ? Color.red : Color.gray)
                        .animation(.linear(duration: 0.001), value: invalidFields.contains("title"))
                        .padding(.horizontal)
                }
                TextField("", text: $eventTitle)
                    .padding()
                    .background(Color.clear)
                    .frame(maxWidth:200)
                    .frame(maxHeight:20)
                    .cornerRadius(8)
                    .textFieldStyle(.plain)
            }
            Rectangle()
                .frame(width:200,height:2)
                .foregroundStyle(invalidFields.contains("title") ? Color.red.opacity(0.5) : Color.black)
                .animation(.linear(duration: 0.001), value: invalidFields.contains("title"))

            
        }
    }
    
    private var eventVenue : some View {
        VStack(alignment: .center, spacing: 5) {
            Text("Where will it be?")
                .font(.headline)
            ZStack(alignment: .leading) {
                // Placeholder text
                if eventLocation.isEmpty {
                    Text("Event Location")
                        .foregroundStyle(invalidFields.contains("location") ? Color.red : Color.gray)
                        .animation(.linear(duration: 0.001), value: invalidFields.contains("location"))

                        .padding(.horizontal)
                       
                }
                TextField("", text: $eventLocation)
                
                    .padding()
                //                .background(Color.clear)
                    .frame(maxWidth:200)
                    .frame(maxHeight:20)
                    .cornerRadius(8)
                    .textFieldStyle(.plain)
                
            }
            Rectangle()
                .frame(width:200,height:2)
                .foregroundStyle(invalidFields.contains("location") ? Color.red.opacity(0.5) : Color.black)
                .animation(.linear(duration: 0.001), value: invalidFields.contains("location"))
             
            

            
            
        }
    }
    
    private var eventDateTime : some View {
        VStack(spacing: 10) {
            HStack {
                Text("Start:")
                Spacer()
                DatePicker("",
                           selection: $startDate,
                           in: Date()...,
                           displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .datePickerStyle(.compact)
                .overlay(
                        invalidFields.contains("invalidDateRange") ? Color.red.frame(height: 1) : Color.clear.frame(height: 1),
                        alignment: .bottom
                    )
            }
            HStack {
                Text("End:")
                Spacer()
                DatePicker("",
                           selection: $endDate,
                           in: Date()...,
                           displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
                .overlay(
                        invalidFields.contains("invalidDateRange") ? Color.red.frame(height: 1) : Color.clear.frame(height: 1),
                        alignment: .bottom
                    )
            }
        }
    }
    
    private var eventCategory : some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category")
                .font(.headline)
            Text("Please select at least 3 categories")
                .font(.subheadline)
                .foregroundStyle(invalidFields.contains("categories") ? Color.red : Color.gray)
                .animation(.linear, value: invalidFields.contains("categories"))

            
            HStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                    ForEach(categories.prefix(isCategoryExpanded ? categories.count : 3), id: \.self) { category in
                        Button(action: {
                            toggleCategory(category)
                        }) {
                            
                            Text(category)
                                .foregroundStyle(Color.black)
                                .padding(.horizontal)
                                .background(selectedCategories.contains(category) ? Color.blue.opacity(0.65) : Color.gray.opacity(0.2))
                                .cornerRadius(30)
                        }
                    }
                }
                .frame(maxWidth:350)
                
                
                // Expand/Collapse Button
                Button(action: {
                    withAnimation(.linear(duration: 0.35)){
                        isCategoryExpanded.toggle()
                    }
                }) {
                    Circle()
                        .frame(height:27)
                        .foregroundStyle(Color.black)
                        .overlay (
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees(isCategoryExpanded ? 180 : 0))
                                .foregroundStyle(.white)
                        )
                    
                }
                Spacer()
            }
            
            
        }
    }
    
    private var eventAdditionalInfo : some View {
        VStack(alignment: .leading) {
            Text("Additional info")
                .font(.headline)
            
            ZStack(alignment: .topLeading) {
                // Placeholder text
                if additionalInfo.isEmpty {
                    Text("Share the details here...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $additionalInfo)
                    .frame(height: 150)
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .background(additionalInfo.isEmpty ? Color.red.opacity(0.3) : Color.clear)

            }
        }
    }
    
    private var isFormValid: Bool {
           !eventTitle.isEmpty && !eventLocation.isEmpty && !additionalInfo.isEmpty && selectedCategories.count >= 3 && (endDate > startDate)
       }
}
