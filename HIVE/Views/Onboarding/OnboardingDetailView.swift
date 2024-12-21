//
//  OnboardingDetailView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct OnboardingDetailView: View {
  var onboardingSteps: [OnboardingStep]
  var currentStep: Int
  
  @ObservedObject var viewModel: OnboardingViewModel
  
  let options: [BioType] = [.locall, .travelling, .newInTown, .expat]
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  @State private var isPickerPresented = false
  @State private var isUploading = false
  @FocusState.Binding var isFocused: Bool
  
  var body: some View {
    VStack(alignment: .leading){
      Text(onboardingSteps[currentStep].title)
        .frame(maxWidth: .infinity, alignment: .leading)
        .heading1()
      Text(onboardingSteps[currentStep].description)
        .frame(maxWidth: .infinity, alignment: .leading)
        .body5()
      
      switch onboardingSteps[currentStep].type{
      case .Name:
        ZStack {
          Color.white
            .edgesIgnoringSafeArea(.all)
          Spacer()
          VStack{
              TextEditorWithPlaceholder(text: $viewModel.name, wordCount: 20, isFocused: $isFocused)
              .lineLimit(1)
          }.frame(maxWidth: .infinity, maxHeight: 50)
          Spacer()
        }
      case .Birthday:
        ZStack {
          Color.white
            .edgesIgnoringSafeArea(.all)
          VStack {
            DatePicker("", selection: $viewModel.birthday, displayedComponents: .date)
              .datePickerStyle(.wheel)
              .labelsHidden() // Hides label to avoid blank space
              .environment(\.locale, Locale(identifier: "en_US")) // Sets to US format
              .padding()
            
            
          }
          Spacer()
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
        }
      case .Gender:
        VStack {
          Picker("Gender", selection: $viewModel.gender) {
            Text("Male")
                  .tag(Gender.male)
                  .body5()
            Text("Female")
                  .tag(Gender.female)
                  .body5()
            Text("Diverse")
                  .tag(Gender.diverse)
                  .body5()
          }
          
          .pickerStyle(SegmentedPickerStyle())
          .padding()
        }
        Spacer(minLength: 0)
        
      case .Pfp:
        VStack(alignment: .center) {
          Spacer()
            .frame(height: 100)
          // Display the selected image or prompt the user to select an image
          RoundedRectangle(cornerRadius: 30)
            .frame(width: 300, height: 300)
            .foregroundStyle(Color("hive_gray"))
            .overlay {
              if let profileImage = viewModel.profileImage {
                Image(uiImage: profileImage)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 300, height: 300)
                  .clipShape(RoundedRectangle(cornerRadius: 30))
              } else {
                Image("image_placeholder")
                  .resizable()
                  .frame(width: 100, height: 100)
                  .aspectRatio(contentMode: .fit)
              }
            }
            .onTapGesture {
              viewModel.isPickerPresented = true
              
            }
            .sheet(isPresented: $viewModel.isPickerPresented) {
              PhotoPicker(selectedImage: $viewModel.profileImage)
            }
          // Show a progress view if uploading
          if viewModel.isUploading {
            ProgressView("Uploading...")
          }
        }
        .frame(maxWidth: .infinity)
        
      case .SelfInfo:
        ZStack {
          Color.white
            .ignoresSafeArea(edges: .all)
        VStack(alignment: .leading) {
          LazyVGrid(columns: columns, spacing: 10) {
            ForEach(options, id: \.self) { option in
              RectangleOption(option: option.rawValue, isSelected: viewModel.bioType == option) {
                // Set the selected option, or deselect if the same option is clicked again
                if viewModel.bioType == option {
                  viewModel.bioType = nil // Deselect the option
                } else {
                  viewModel.bioType = option // Select the new option
                }
              }
              .frame(height: 100) // Set height for each rectangle
            }
          }
          .padding(.top)
          Spacer()
            .frame(height: 80)
          VStack{
            ZStack(alignment: .topLeading) {
              RoundedRectangle(cornerRadius: 8)
                .fill(Color("hive_gray"))
                .overlay(
                  GeometryReader { geometry in
                    Color.clear
                      .frame(height: geometry.size.height) // Match the background to TextField's height
                  }
                )
              
              TextField("Tell others a bit about yourself...", text: $viewModel.bio, axis: .vertical)
                .textFieldStyle(PlainTextFieldStyle()) // Use Plain style to avoid white background
                .padding(16) // Add padding within the TextField
                .foregroundColor(.black) // Text color
                .body5()
                .lineLimit(4, reservesSpace: true)
                .background(Color.clear)
                .limitInputLength(value: $viewModel.bio, length: 60)
                .focused($isFocused)
            }
            .padding()
            .frame(maxWidth: .infinity)
          }.frame(maxHeight: 100)
          
          
        }
      }
      
      }
    }
  
    .frame(maxWidth: .infinity)
    .id(currentStep)
    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
    .animation(.linear, value: currentStep)
    .onTapGesture {
      if currentStep != 3 {
        self.hideKeyboard()
        print("keyboard hide")
        isFocused = false
      }
    }
    .onChange(of: isFocused) { _, _ in
//        if oldValue != newValue{
//            UIApplication.shared.endEditing()
//        }
    }
    
  }
}

struct RectangleOption: View {
  let option: String
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(option)
        .body5()
        .frame(maxWidth: .infinity)
        .padding()
        .background(isSelected ? Color.black : Color("hive_gray"))
        .foregroundColor(isSelected ? .white : .black)
        .cornerRadius(8)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(isSelected ? Color.black : Color.gray, lineWidth: 1)
        )
    }
    .buttonStyle(PlainButtonStyle()) // To prevent the default button style
  }
}

//#Preview {
//    OnboardingDetailView()
//}
