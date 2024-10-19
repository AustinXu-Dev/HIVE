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
    
    var body: some View {
        VStack(alignment: .leading){
            Text(onboardingSteps[currentStep].title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
            Text(onboardingSteps[currentStep].description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
            
            switch onboardingSteps[currentStep].type{
            case .Name:
                TextField("Name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            case .Birthday:
                DatePicker("", selection: $viewModel.birthday, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .padding()

            case .Gender:
                Picker("Gender", selection: $viewModel.gender) {
                    Text("Male").tag(Gender.male)
                    Text("Female").tag(Gender.female)
                    Text("Diverse").tag(Gender.diverse)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

            case .Pfp:
                VStack {
                    // Display the selected image or prompt the user to select an image
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    } else {
                        Text("Select an image")
                            .foregroundColor(.gray)
                            .frame(height: 200)
                    }
                    
                    // Button to trigger the image picker and then upload the image
                    Button(action: {
                        // Present the image picker
                        viewModel.isPickerPresented = true // This flag triggers the image picker
                    }) {
                        Text("Select Image")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $viewModel.isPickerPresented) {
                        PhotoPicker(selectedImage: $viewModel.profileImage)
                    }

                    // Button to trigger the upload
                    Button(action: {
                        // Call the uploadProfileImage() function in the ViewModel
                        viewModel.uploadProfileImage()
                    }) {
                        Text("Upload Image")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    // Show a progress view if uploading
                    if viewModel.isUploading {
                        ProgressView("Uploading...")
                    }
                }

            case .SelfInfo:
                VStack(alignment: .leading) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(options, id: \.self) { option in
                            RectangleOption(option: option.rawValue, isSelected: viewModel.bioType.contains(option)) {
                                if viewModel.bioType.contains(option) {
                                    viewModel.bioType.remove(option)
                                } else {
                                    viewModel.bioType.insert(option)
                                }
                            }
                            .frame(height: 100) // Set height for each rectangle
                        }
                    }
                    .padding(.top)
                    TextField("Tell others a bit about yourself...", text: $viewModel.bio, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .lineLimit(3, reservesSpace: true)
                }

            }
        }
        .frame(maxWidth: .infinity)
        .id(currentStep)
        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
        .animation(.linear, value: currentStep)
        
    }
}

struct RectangleOption: View {
    let option: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(option)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSelected ? Color.black : Color.gray.opacity(0.2))
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

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}
