//
//  VideoView.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/19.
//
import SwiftUI
import MetalKit

struct VideoView: NSViewRepresentable {
  typealias NSViewType = MTKView
  
  private let device: MTLDevice
  private let capturer: ScreenCapturer
  
  private let size = CGSize(width: 3072, height: 1920)
  
  init() {
    guard let device = MTLCreateSystemDefaultDevice() else {
      fatalError()
    }
    self.device = device
    self.capturer = ScreenCapturer(device: device)
    self.capturer.startScreencast()
  }
        
  func makeNSView(context: Context) -> MTKView {
    debugPrint("VideoRendererView is created")
    // see: https://stackoverflow.com/questions/60737807/cametallayer-nextdrawable-returning-nil-because-allocation-failed
  
    let view = MTKView()
    view.framebufferOnly = false
    view.autoResizeDrawable = false
    view.clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1)
    view.device = device
    view.delegate = context.coordinator
    context.coordinator.setup(device: device)
    return view
  }

  func updateNSView(_ nsView: MTKView, context: Context) {
    debugPrint("VideoRendererView is updated")
    nsView.drawableSize = self.size
  }
  
  func makeCoordinator() -> Renderer {
    return Renderer(view: self, capturer: self.capturer)
  }
}
