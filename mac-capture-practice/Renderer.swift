//
//  Renderer.swift
//  mac-capture-practice
//
//  Created by Takaaki Suzuki on 2021/03/20.
//
import Foundation
import MetalKit
import AVFoundation

class Renderer: NSObject {
  
  private let parent: VideoView
  private var device: MTLDevice?
  private var commandQueue: MTLCommandQueue?
  
  private let semaphore = DispatchSemaphore(value: 3)
  
  private var capturer: ScreenCapturer?
  
  init(view: VideoView) {
    self.parent = view
  }
  
  func setup(device: MTLDevice) {
    self.device = device
    self.commandQueue = device.makeCommandQueue()
    let capturer = ScreenCapturer(device: device)
    self.capturer = capturer
    capturer.startScreencast()
  }
}

extension Renderer: MTKViewDelegate {
  
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    debugPrint(size)
  }
  
  func draw(in view: MTKView) {
//    autoreleasepool {
      // see: https://stackoverflow.com/questions/31188378/cametallayer-nextdrawable-issue-on-osx-10-11-beta-2
//      semaphore.wait()
      
      guard let capturer = self.capturer else {
        return
      }
    
      guard let commandBuffer = commandQueue?.makeCommandBuffer() else {
        return
      }
      
      guard let encoder = commandBuffer.makeBlitCommandEncoder() else {
        return
      }
    
      guard let drawable = view.currentDrawable else {
        return
      }
    
    if let texture = capturer.texture {
        encoder.copy(from: texture,
                     sourceSlice: 0,
                     sourceLevel: 0,
                     sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                     sourceSize: MTLSizeMake(texture.width, texture.height, texture.depth),
                     to: drawable.texture,
                     destinationSlice: 0,
                     destinationLevel: 0,
                     destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
      }
      encoder.endEncoding()
      
//      commandBuffer.addCompletedHandler { _ in
//          self.semaphore.signal()
//      }
      commandBuffer.present(drawable)
      commandBuffer.commit()
      commandBuffer.waitUntilCompleted()
    }
//  }
  
}
