//
//  ProfileView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 20/10/2567 BE.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var profileImage: UIImage? = UIImage(named: "profile")
    @State private var isPickerPresented = false
    @ObservedObject var googleVM = GoogleAuthenticationViewModel()

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Button(action: {
                    isPickerPresented = true
                }) {
                    Image(systemName: "pencil")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Divider()

            if let image = profileImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }

            Text("Harley")
                .font(.title2)
                .fontWeight(.bold)

            Text("(Expat)")
                .foregroundColor(.gray)

            Text("Outgoing expat who loves nightlife 🌃")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button(action: {
            }) {
                HStack {
                    Image(systemName: "camera")
                        .foregroundColor(.pink)
                    Text("Connect me")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(25)
                .padding(.horizontal, 40)
            }

            Spacer()

            Button {
                googleVM.signOutWithGoogle()
            } label: {
                Text("Sign out")
            }

//            HStack {
//                TabBarItem(icon: "house.fill")
//                TabBarItem(icon: "magnifyingglass")
//                TabBarItem(icon: "plus.circle.fill", isCentral: true)
//                TabBarItem(icon: "message.fill")
//                TabBarItem(icon: "person.fill")
//            }
//            .padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $profileImage)
        }
    }
}

struct TabBarItem: View {
    var icon: String
    var isCentral: Bool = false

    var body: some View {
        Button(action: {
            // Tab item action
        }) {
            Image(systemName: icon)
                .font(isCentral ? .largeTitle : .title2)
                .foregroundColor(isCentral ? .black : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

#Preview {
    ProfileView()
}

