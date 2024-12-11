//
//  CameraManager.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 10/12/2567 BE.
//

import Foundation
import AVFoundation
import SwiftUI
import UIKit

class CameraManager: NSObject, ObservableObject {
    var session: AVCaptureSession
    private var photoOutput: AVCapturePhotoOutput
    private var videoDevice: AVCaptureDevice?
    private var photoCaptureDelegate: AVCapturePhotoCaptureDelegate?
    
    @Published var capturedImage: UIImage? = nil
    
    override init() {
        session = AVCaptureSession()
        photoOutput = AVCapturePhotoOutput()
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        session.beginConfiguration()
        
        // Add video input
        if let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
           let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) {
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
            }
        }
        
        // Add photo output
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        session.commitConfiguration()
    }
    
    func startSession() {
        if !session.isRunning {
            DispatchQueue.global(qos: .background).async {
                
                
                self.session.startRunning()
                
            }
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
   
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}
