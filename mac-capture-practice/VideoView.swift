//
//  VideoView.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/19.
//
import SwiftUI
import WebRTC
import MetalKit

struct VideoView: NSViewRepresentable {
  typealias NSViewType = MTKView
    
  @Binding var isRecording: Bool
    
  func makeNSView(context: Context) -> MTKView {
    debugPrint("VideoRendererView is created")
    // see: https://stackoverflow.com/questions/60737807/cametallayer-nextdrawable-returning-nil-because-allocation-failed
    let view = MTKView()
    view.framebufferOnly = false
    view.autoResizeDrawable = false
    view.drawableSize = .init(width: 3584, height: 2240)
    view.clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    if let device = MTLCreateSystemDefaultDevice() {
      view.device = device
      view.delegate = context.coordinator
      context.coordinator.setup(device: device)
    }
    return view
  }

  func updateNSView(_ nsView: MTKView, context: Context) {
    debugPrint("VideoRendererView is updated")
  }
  
  func makeCoordinator() -> Renderer {
    return Renderer(view: self)
  }
}
