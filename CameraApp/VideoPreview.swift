//
//  VideoPreview.swift
//  CameraApp
//
//  Created by Luka Šalipur on 5.8.22..
//

import Foundation
import SwiftUI
import AVKit

struct VideoPreview: View {
    var url: URL
    @Binding var showPreview:Bool
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            VideoPlayer(player: AVPlayer(url:url))
                .aspectRatio(contentMode: .fill)
                .frame(width:size.width, height: size.height)
                .clipShape(RoundedRectangle(cornerRadius: 30, style:.continuous))
                .overlay(alignment: .topLeading) {
                    Button {
                        showPreview.toggle()
                    } label: {
                        Label{
                            Text("Back")
                                .padding(.vertical, 50)
            
                        } icon:{
                            Image(systemName: "chevron.left")
                        }
                        .foregroundColor(.white)
                    }.padding()

                }
        }.ignoresSafeArea(.all)
        
    }
}
