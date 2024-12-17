//
//  ImageCaptureView.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 10/12/2567 BE.
//

import SwiftUI
import Combine
import Vision
import VisionKit
import FirebaseAuth

struct ImageCaptureView: View {
    
    @StateObject private var cameraManager = CameraManager()
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var verified: Bool = false
    
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var viewModel: OnboardingViewModel
    @EnvironmentObject var googleVM: GoogleAuthenticationViewModel

    var body: some View {
        ZStack {
            VStack {
                if let capturedImage = cameraManager.capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320, height: 400)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                .foregroundColor(.black)
                        )
                        .padding()
                        .onAppear {
                            initialize(with: capturedImage)
                        }
                } else {
                    CameraPreview(session: cameraManager.session)
                        .frame(width: 320, height: 400)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                .foregroundColor(.black)
                        )
                        .onAppear {
                            cameraManager.startSession()
                        }
                        .onDisappear {
                            cameraManager.stopSession()
                        }
                }
                
                Text("Center your face and take a clear front facing photo.")
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding()
                
                
                BlackButton(text: "Capture", color: .constant(.black)) {
                    cameraManager.capturePhoto()
                }
                .padding(.top, 20)
                
            }
            
            if isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                ProgressView("Processing...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }

        }
        .alert("Face Verification fail",isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                appCoordinator.pop()
            }
        } message: {
            Text("Please retake the photo again.")
        }
        
        .alert("Face Verification Success",isPresented: $verified) {
            Button("OK", role: .cancel) {
                appCoordinator.push(.verifySuccess)

            }
        } message: {
            Text("Click ok to upload image to the admin.")
        }
    }
    
    func initialize(with image: UIImage) {
        isLoading = true
        
        guard let cgImage = image.cgImage else {
            print("Failed to get CGImage from UIImage")
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        let faceQualityRequest = VNDetectFaceCaptureQualityRequest()
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try requestHandler.perform([faceQualityRequest])
        } catch {
            print("Error performing face detection request: \(error)")
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        
        guard let results = faceQualityRequest.results, !results.isEmpty else {
            print("No face detected in the image")
            DispatchQueue.main.async {
                self.isLoading = false
                self.showAlert = true
                cameraManager.capturedImage = nil // Clear the captured image
            }
            return
        }
        
        for result in results {
            let quality = result.faceCaptureQuality ?? -1
            print("Face capture quality: \(quality)")
            
            if quality < 0.5 {
                print("Face quality too low: \(quality)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showAlert = true
                    cameraManager.capturedImage = nil // Clear the captured image
                }
            } else {
                print("Verified, quality: \(quality)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.verified = true
                    viewModel.verificationImage = cameraManager.capturedImage // Store the verified image
                }
            }
        }
    }
}

#Preview {
    ImageCaptureView()
}
