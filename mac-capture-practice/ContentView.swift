//
//  ContentView.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/19.
//

import SwiftUI
import WebRTC

struct ContentView: View {
    
  private var view: RTCMTLNSVideoView
  private var capturer: ScreenCapturer
    
  init() {
    self.view = RTCMTLNSVideoView()
    self.capturer = ScreenCapturer(view: self.view)
  }
  
    var body: some View {
      VStack {
        VideoView(view: view).frame(width: 300, height: 300)
        HStack {
          Button("Start", action: {
            capturer.startScreencast()
          })
          Button("Stop", action: {
            capturer.stopScreencast()
          })
        }
      }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
