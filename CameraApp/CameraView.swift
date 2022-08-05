//
//  CameraView.swift
//  CameraApp
//
//  Created by Luka Šalipur on 5.8.22..
//

import SwiftUI



struct CameraView: View {
    @StateObject var camera = CameraModel()
    @State private var longPressure = false
    @State private var animationAmount = 0.0
    @State private var showPreviewButton = false
    var body: some View {

        ZStack{
            GeometryReader { proxy in
                let size = proxy.size
                
                CameraLivePreview(camera: camera)
                .ignoresSafeArea(.all)
         
                if camera.isPhotoTaken{
            ZStack{
                VStack{
                HStack{
                    
                    Button{
                        camera.reTake()
                    }label:{
                        Image(systemName: "camera.fill")
                            .font(.system(size:35))
                            .foregroundColor(.white)
                            .padding(10)
                        
                    }
                }
                }.frame(maxWidth:.infinity,
                        maxHeight:size.height, alignment: .topTrailing)
            }
                }
                if !camera.isPhotoTaken{
            ZStack{
                
                
                VStack{
                    Spacer()
                    HStack{
                  
                    Button {
                        if !camera.isSaved {
                            if longPressure {
                                self.longPressure = false
                             
                                camera.stopRecording()
                                self.showPreviewButton = true
                                self.animationAmount = 0
                            } else {
                                camera.takePic()
                            }
                            
                           
                        }
                    } label: {
                        ZStack{
                        Circle()
                            .stroke( Color.white, lineWidth: 5)
                            .frame(width: 75, height: 75)
                            
                            Circle()
                                  .fill(.red)
                                  .opacity(longPressure ? 1 : 0)
                                  .scaleEffect(animationAmount)
                                  .animation(.easeInOut(duration:0.2), value: animationAmount)
                                  .frame(width: 65, height: 65)
                        }
                    } .simultaneousGesture(
                        LongPressGesture().onEnded { _ in self.longPressure = true
                            camera.startRecording()
                            animationAmount += 1
                            self.showPreviewButton = false
                        }
                      )
                    
                    }.frame(maxWidth:.infinity,  alignment: .center)
                    
                       
                }
            }
                }
                
                if camera.isPhotoTaken{
                    ZStack{
                        VStack{
                            Spacer()
                            HStack{
                                Button {
                                    camera.savePhoto()
                                } label: {
                                    Capsule()
                                        .fill(Color.white)
                                        .frame(width:80, height:40)
                                        .overlay(
                                            Text(camera.isSaved ? "Saved" : "Save").foregroundColor(.black))
                                       
                                }
                            }.frame(maxWidth:.infinity, alignment: .leading)
                                .padding()
                        }
                    }
                    
                    
                }
                if showPreviewButton  && !camera.isPhotoTaken{
                ZStack{
                    VStack{
                        Spacer()
                        HStack{
                            Button {
                                camera.showPreview.toggle()
                        
                            } label: {
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width:80, height:40)
                                    .overlay(
                                        Text("Preview").foregroundColor(.black))
                                   
                            }
                        }.frame(maxWidth:.infinity, alignment: .trailing)
                            .padding()
                    }
                }
                }
            
        }.onAppear{
            camera.check()
        }.overlay( content: {
            if let url = camera.previewURL, camera.showPreview{
                VideoPreview(url:url, showPreview: $camera.showPreview).transition(.move(edge: .trailing))
          
            }
        }
               )
    }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
