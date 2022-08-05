//
//  CameraLivePreview.swift
//  CameraApp
//
//  Created by Luka Šalipur on 5.8.22..
//

import Foundation
import AVFoundation
import SwiftUI

struct CameraLivePreview: UIViewRepresentable {
   
    
    @ObservedObject var camera = CameraModel()
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session:camera.session)
        camera.preview.frame = view.frame
        camera.preview.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
