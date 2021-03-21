//
//  ContentView.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/19.
//

import SwiftUI
import MetalKit

struct ContentView: View {
  
  var body: some View {
    VStack {
      VideoView()
    }
  }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
