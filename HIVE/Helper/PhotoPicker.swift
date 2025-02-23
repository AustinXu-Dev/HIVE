//
//  PhotoPicker.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 26/11/2567 BE.
//

import Foundation
import SwiftUI
import TOCropViewController

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let cropSize: CGSize? // Optional crop size
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                let cropViewController = TOCropViewController(image: image)
                cropViewController.delegate = self

                // Configure cropping based on whether cropSize is provided
                if let size = parent.cropSize {
                    cropViewController.customAspectRatio = size
                    cropViewController.aspectRatioLockEnabled = true
                    cropViewController.resetAspectRatioEnabled = false
                } else {
                    // No cropSize provided: allow freeform cropping
                    cropViewController.aspectRatioLockEnabled = false
                    cropViewController.resetAspectRatioEnabled = true
                }

                picker.present(cropViewController, animated: true, completion: nil)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with rect: CGRect, angle: Int) {
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }

        func cropViewControllerDidCancel(_ cropViewController: TOCropViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Old version
//struct PhotoPicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = .photoLibrary
//        picker.delegate = context.coordinator
//        picker.allowsEditing = true // Enable editing
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: PhotoPicker
//
//        init(_ parent: PhotoPicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            picker.dismiss(animated: true)
//
//            // Retrieve the edited image if available; fall back to the original image
//            if let editedImage = info[.editedImage] as? UIImage {
//                parent.selectedImage = editedImage
//            } else if let originalImage = info[.originalImage] as? UIImage {
//                parent.selectedImage = originalImage
//            }
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//        }
//    }
//}

