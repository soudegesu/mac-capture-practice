//
//  ContentView.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/19.
//

import SwiftUI
import MetalKit

struct ContentView: View {
    
  @State private var isRecording: Bool = false
      
  var body: some View {
    VStack {
      VideoView(isRecording: $isRecording)
      HStack {
        Button("Start", action: {
          isRecording = true
        })
        Button("Stop", action: {
          isRecording = false
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
