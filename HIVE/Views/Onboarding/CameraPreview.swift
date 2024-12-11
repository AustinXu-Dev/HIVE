//
//  CameraPreview.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 10/12/2567 BE.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    class CameraView: UIView {
        var session: AVCaptureSession
        
        init(session: AVCaptureSession) {
            self.session = session
            super.init(frame: .zero)
            
            // Set up the preview layer
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = bounds
            layer.addSublayer(previewLayer)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            // Ensure the preview layer matches the view's bounds
            (layer.sublayers?.first as? AVCaptureVideoPreviewLayer)?.frame = bounds
            
            // Add circular masking
            layer.cornerRadius = bounds.width / 2
            layer.masksToBounds = true
        }
    }
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraView {
        CameraView(session: session)
    }
    
    func updateUIView(_ uiView: CameraView, context: Context) {}
}
