//
//  CameraModel.swift
//  CameraApp
//
//  Created by Luka Šalipur on 5.8.22..
//

import Foundation
import SwiftUI
import AVFoundation



class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    
    @Published var isPhotoTaken: Bool = false
    @Published var isSaved: Bool = false
    @Published var isRecording: Bool = false
    
    @Published var pictureData: Data = Data(count: 0)
    
    @Published var session = AVCaptureSession()
    @Published var photoOutput = AVCapturePhotoOutput()
    @Published var videoOutput = AVCaptureMovieFileOutput()
    @Published var preview = AVCaptureVideoPreviewLayer()
    
    @Published var previewURL: URL?
    @Published var showPreview: Bool = false

    
    @Published var alert = false
    
    // Setting camera section
    
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
            
        case .restricted:
            return
        case .denied:
            self.alert.toggle()
            return
        case .authorized:
        setUp()
            return
        @unknown default:
            return
        }
    }
    func setUp(){
        
        do {
            let device = AVCaptureDevice.default(for: .video)
            
            if device != nil {
                let input = try AVCaptureDeviceInput(device: device!)
                self.session.canAddInput(input)
                self.session.addInput(input)
            } else {
                return
            }
            
            let audioDevice = AVCaptureDevice.default(for: .audio)
            
            if audioDevice != nil {
                let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
                self.session.canAddInput(audioInput)
                self.session.addInput(audioInput)
            } else {
                return
            }
            
            if self.session.canAddOutput(photoOutput){
                self.session.addOutput(photoOutput)
               
            }
            
            if self.session.canAddOutput(videoOutput){
                self.session.addOutput(videoOutput)
            }
            
            
        } catch {
            print(error.localizedDescription)

        }
    }
    
    // Capture photo section
    
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isPhotoTaken.toggle()}
                
                print("Photo taken")
            }
        }
    }
    
    func reTake(){
        DispatchQueue.global(qos:.background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isPhotoTaken.toggle()}
                
                self.isSaved = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.pictureData = imageData
        
    }
    
    func savePhoto(){


       
        if let image = UIImage(data: self.pictureData) {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            self.isSaved = true
        } else {
            
        return
        }
   
       
    }
    
    
    // Recording video section
    
    func startRecording(){
        let tempURL = NSTemporaryDirectory() + "\(Date()).mov" // Making a temporary directory
        videoOutput.startRecording(to: URL(fileURLWithPath: tempURL), recordingDelegate: self) // Saving video to this temporaryURL
        self.isRecording = true
    }
    
    func stopRecording(){
        videoOutput.stopRecording()
        self.isRecording = false
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print(outputFileURL)
        self.previewURL = outputFileURL
    }
    
}
